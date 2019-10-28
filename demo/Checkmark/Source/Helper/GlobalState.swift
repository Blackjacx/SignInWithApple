import Foundation
import AuthenticationServices

enum GlobalState {
    static var userId: String?
    static var appleIdCredential: ASAuthorizationAppleIDCredential?

    static func reset() {
        userId = nil
        appleIdCredential = nil
    }
}
