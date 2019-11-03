import Foundation
import AuthenticationServices

enum GlobalState {
    static var appleIdCredential: ASAuthorizationAppleIDCredential?

    static func reset() {
        appleIdCredential = nil
    }
}
