import UIKit
import AuthenticationServices

final class SignInViewController: UIViewController {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let keychain = Keychain()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDivider()
        setupSignInWithAppleButton()
        setupRevokationListener()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Check if the userId is saved in keychain
        if let userId = keychain.string(for: Constants.Keys.userId) {

            let provider = ASAuthorizationAppleIDProvider()

            // Very fast API to be called on app launch to handle log-in state appropriately.
            provider.getCredentialState(forUserID: userId) { [weak self] (state, error) in

                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .authorized:   self?.performSignIn(userId: userId) // Apple ID credential is valid
                    case .revoked:      break // Apple ID credential revoked, sign user out on device and show sign in screen
                    case .notFound:     break // Apple ID credential not found, show signIn UI
                    case .transferred:  break
                    @unknown default:   break
                    }
                }
            }
        }
    }

    private func setupDivider() {
        let divider = DividerView(text: "or", color: .systemGray2)
        stack.addArrangedSubview(divider)
    }

    private func setupSignInWithAppleButton() {
        let button = ASAuthorizationAppleIDButton()
        button.cornerRadius = 22
        let selector = #selector(didPressSignInWithApple)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stack.addArrangedSubview(button)
    }

    private func setupRevokationListener() {
        let name = ASAuthorizationAppleIDProvider.credentialRevokedNotification
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.performSignOut()
            }
        }
    }

    @objc
    func didPressSignInWithApple(_ sender: UIButton) {
        let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
        // optional - only request what's required
        appleIdRequest.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    private func performSignIn(userId: String, credential: ASAuthorizationAppleIDCredential? = nil) {
        // For the purpose of this demoapp, remember the credential
        GlobalState.appleIdCredential = credential
        GlobalState.userId = userId
        performSegue(withIdentifier: Constants.Segues.sinInSuccess, sender: nil)
    }

    private func performSignOut() {
        emailTextField.text = nil
        passwordTextField.text = nil
        keychain.remove(for: Constants.Keys.userId)
        GlobalState.reset()
        dismiss(animated: true, completion: nil)
    }

    // MARK: - IB Support

    @IBAction
    func prepareForUnwind(segue: UIStoryboardSegue) {
        performSignOut()
    }
    
    @IBAction func didPressSignIn(_ sender: UIButton) {
        guard emailTextField.text?.isEmpty == false &&
            passwordTextField.text?.isEmpty == false else {
                return
        }
        performSegue(withIdentifier: Constants.Segues.sinInSuccess, sender: nil)
    }
}

// Delegates are guaranteed to be called on the apps main queue
extension SignInViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:

            // Use credential ONLY to create account on your server.
            // For the purpose of this demo app, store userId in keychain ans pass credential
            keychain.set(appleIdCredential.user, key: Constants.Keys.userId)

            performSignIn(userId: appleIdCredential.user, credential: appleIdCredential)

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle userCancelled or any error
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: textField.resignFirstResponder()
        default: break
        }
        return true
    }
}
