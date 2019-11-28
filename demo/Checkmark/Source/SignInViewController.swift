import UIKit
import AuthenticationServices

final class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignInWithAppleButton()
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

    private func handleSuccessfulSignIn() {
        // Dismiss SignInViewController
        dismiss(animated: true)
    }

    // MARK: - Button Actions

    @objc func didPressSignInWithApple(_ sender: UIButton) {
        let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
        // optional - only request what's required
        appleIdRequest.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest])
        controller.presentationContextProvider = self
        controller.delegate = self
        controller.performRequests()
    }

    @IBAction func didPressSignInWithEmail(_ sender: UIButton) {
        guard emailTextField.text?.isEmpty == false &&
            passwordTextField.text?.isEmpty == false else {
                return
        }

        // Get access token and store it in keychain

        handleSuccessfulSignIn()
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
            Keychain.shared.set(userId, key: Constants.Keys.userId)

            // Register or sign in
            if credential.fullName != nil &&
                credential.email != nil &&
                credential.identityToken != nil &&
                credential.authorizationCode != nil {

                // Register NEW account
            } else {
                // Login
            }

            // Use credential ONLY to create account on your server!
            // For the purpose of this demo, remember it.
            GlobalState.appleIdCredential = credential

            handleSuccessfulSignIn()

        case let credential as ASPasswordCredential:
            print("Received credential from keychain \(credential.user)")
            break

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle userCancelled and other errors
    }
}
