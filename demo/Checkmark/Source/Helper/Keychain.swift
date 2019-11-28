import UIKit

/// For demo purposes this uses the standard UserDefaults. NEVER do this for
/// production code! Credentials really need to be stored in the keychain. There
/// are a couple of nice frameworks that do a good job! Just search for
/// `swift keychain wrapper github`.
struct Keychain {

    static let shared = Keychain()
    
    func set(_ text: String, key: String) {
        UserDefaults.standard.set(text, forKey: key)
    }

    func remove(for key: String) {
        UserDefaults.standard.set(nil, forKey: key)
    }

    func string(for key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }

    func signOut() {
        remove(for: Constants.Keys.userId)
    }
}
