import UIKit
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let userId = Keychain.shared.string(for: Constants.Keys.userId) ?? ""
        let provider = ASAuthorizationAppleIDProvider()

        // Fast API to be called on app launch to handle log-in state appropriately.
        provider.getCredentialState(forUserID: userId) { [weak self] (credentialState, error) in

            switch credentialState {
            case .authorized:
                break // The Apple ID credential is valid.

            case .revoked, .notFound:

                // Apple ID credential revoked -> sign user out on device
                // - or -
                // The Apple ID credential was not found.
                //
                // Show the sign-in UI.

                self?.showLoginScreen()

            default:
                break
            }
        }

        return true
    }

    private func showLoginScreen() {

        DispatchQueue.main.async { [weak self] in
            let viewController = Constants.signInViewController
            self?.window?.rootViewController?.present(viewController,
                                                      animated: true,
                                                      completion: nil)
        }
    }
}


