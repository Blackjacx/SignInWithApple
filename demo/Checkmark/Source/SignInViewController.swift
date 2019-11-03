import UIKit
import AuthenticationServices

final class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let keychain = Keychain()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSignInWithAppleButton()
        setupRevokationListener()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let userId = keychain.string(for: Constants.Keys.userId) {

            // Sign in with Apple userId found in keychain

            let provider = ASAuthorizationAppleIDProvider()

            // Very fast API to be called on app launch to handle log-in state appropriately.
            provider.getCredentialState(forUserID: userId) { [weak self] (state, error) in

                DispatchQueue.main.async { [weak self] in
                    switch state {
                    case .authorized:   self?.performSignIn() // Apple ID credential is valid
                    case .revoked:      break // Apple ID credential revoked, sign user out on device and show sign in screen
                    case .notFound:     break // Apple ID credential not found, show signIn UI
                    case .transferred:  break
                    @unknown default:   break
                    }
                }
            }
        }
    }

    // MARK: - Setup Sign in with Apple Button

    private func setupSignInWithAppleButton() {
        let divider = DividerView(text: "or", color: .systemGray2)
        stack.addArrangedSubview(divider)

        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                  authorizationButtonStyle: .black)
        let selector = #selector(didPressSignInWithApple)
        button.addTarget(self, action: selector, for: .touchUpInside)

        // Apply app style
        button.cornerRadius = 22
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        stack.addArrangedSubview(button)
    }

    @objc func didPressSignInWithApple(_ sender: UIButton) {
        let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
        // optional - only request what's required
        appleIdRequest.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest])
        controller.presentationContextProvider = self
        controller.delegate = self
        controller.performRequests()
    }

    // MARK: - Setup Revocation Listener

    private func setupRevokationListener() {
        let center = NotificationCenter.default
        let name = ASAuthorizationAppleIDProvider.credentialRevokedNotification
        center.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.performSignOut()
            }
        }
    }

    private func performSignIn() {
        performSegue(withIdentifier: Constants.Segues.signedInSuccess, sender: nil)
    }

    private func performSignOut() {
        emailTextField.text = nil
        passwordTextField.text = nil
        keychain.signOut()
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

        // Exchange email & password for access token and store it in keychain

        performSignIn()
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: textField.resignFirstResponder()
        default: break
        }
        return true
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        // Return the window the auth dialog should be presented on.
        // Important for multi-window environments, e.g. common on iPad
        return view.window!
    }
}

// Delegates are guaranteed to be called on the apps main queue
extension SignInViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:

            let userId: String = credential.user

            // Store userID in keychain
            keychain.set(userId, key: Constants.Keys.userId)

            // Register or sign in
            if credential.fullName != nil &&
                credential.email != nil &&
                credential.identityToken != nil &&
                credential.authorizationCode != nil {

                // register NEW account - returns you a token
            } else {
                // get token from backend
            }

            // Use credential ONLY to create account on your server!
            // For the purpose of this demo, remember it.
            GlobalState.appleIdCredential = credential

            performSignIn()

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle userCancelled or any error
    }
}
