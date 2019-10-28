import UIKit
import AuthenticationServices

final class SignInViewController: UIViewController {

    @IBOutlet weak var stack: UIStackView!
    private var credential: ASAuthorizationAppleIDCredential?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSignInWithAppleButton()
        setupRevokationListener()

        print("bar")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }

    private func setupSignInWithAppleButton() {
        let button = ASAuthorizationAppleIDButton()
        button.cornerRadius = 22
        let selector = #selector(handleSignInWithAppleIdButtonPress)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stack.addArrangedSubview(button)
    }

    private func setupRevokationListener() {
        let center = NotificationCenter.default
        let name = ASAuthorizationAppleIDProvider.credentialRevokedNotification
        center.addObserver(forName: name, object: nil, queue: nil) { (notification) in
            // Sign user out, optionally guide user to sign in again
        }
    }

    @objc
    func handleSignInWithAppleIdButtonPress(_ sender: UIButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        // optional - only request what's required
        request.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    /// Prompts the user if existing Apple ID credential or iCloud Keychain
    /// credential exists.
    func performExistingAccountSetupFlows() {
        let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
        let passwordRequest = ASAuthorizationPasswordProvider().createRequest()
        // optional - only request what's required
        appleIdRequest.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest, passwordRequest])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    private func saveUserId(_ userId: String) {

    }
}

// Delegates are guaranteed to be called on the apps main queue
extension SignInViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:

            // Create account on your server.
            // For the purpose of this demo app, store the user identifier in
            // the keychain.
            let userId = appleIdCredential.user
            saveUserId(userId)

            // For this demo display the Apple ID credential info.
            let controller = CredentialInfoViewController(credential: appleIdCredential)
            present(controller, animated: true, completion: nil)

        case let passwordCredential as ASPasswordCredential:
            // Sign the user in with their existing iCloud Keychain credential.
            // For the purpose of this demo show the credential as an alert.
            break

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
