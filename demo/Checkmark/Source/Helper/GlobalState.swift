import Foundation
import AuthenticationServices

enum GlobalState {
    static var appleIdCredential: ASAuthorizationAppleIDCredential?

    static func reset() {
        appleIdCredential = nil
    }

    // MARK: - Sign out

    static func performSignOut() {
        Keychain.shared.signOut()
        GlobalState.reset()

        let viewController = Constants.signInViewController
        UIApplication.shared.delegate?.window??.rootViewController?.present(viewController,
                                                                            animated: true,
                                                                            completion: nil)
    }
}
