import UIKit
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let userId = Keychain.shared.string(for: Constants.Keys.userId) else {
            performSignOut()
            return true
        }

        let appleIDProvider = ASAuthorizationAppleIDProvider()

        // Fast API to be called on app launch to handle log-in state appropriately.
        appleIDProvider.getCredentialState(forUserID: userId) { [weak self] (credentialState, error) in

            switch credentialState {
            case .authorized:
                break // The Apple ID credential is valid.

            case .revoked, .notFound:

                // Apple ID credential revoked
                // - or -
                // The Apple ID credential was not found.
                //
                // Show the sign-in UI.

                self?.performSignOut()

            default:
                break
            }
        }

        // Setup Revocation Listener

        let center = NotificationCenter.default
        let name = ASAuthorizationAppleIDProvider.credentialRevokedNotification
        center.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                guard self?.window?.rootViewController?.presentingViewController == nil else {return}
                self?.performSignOut()
            }
        }

        return true
    }

    private func performSignOut() {

        DispatchQueue.main.async {
            GlobalState.performSignOut()
        }
    }
}


