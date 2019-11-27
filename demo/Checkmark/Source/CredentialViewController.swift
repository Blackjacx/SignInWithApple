import UIKit
import AuthenticationServices

final class CredentialViewController: UIViewController {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var realUserLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Unique, stable team-scoped user id.
        // Stable across platforms and devices.
        let userId = Keychain().string(for: Constants.Keys.userId).map {
            return $0.dropLast(20) + String(repeating: "*", count: 20)
        } ?? "-"
        let credential = GlobalState.appleIdCredential

        // Identity token and authCode can be exchanged for an access token on
        // your backend
//        let identityToken = credential?.identityToken
//        let authCode = credential?.authorizationCode

        userIdLabel.text = userId
        givenNameLabel.text = credential?.fullName?.givenName ?? "-"
        familyNameLabel.text = credential?.fullName?.familyName ?? "-"
        emailLabel.text = credential?.email ?? "-"

        // ASUserDetectionStatusUnsupported Not supported on current platform, ignore the value
        // ASUserDetectionStatusUnknown     We could not determine the value.
        //                                  New users in the ecosystem will get this value as well,
        //                                  so you should not blacklist but instead treat these users
        //                                  as any new user through standard email sign up flows.
        // ASUserDetectionStatusLikelyReal  A hint that we have high confidence that the user is real.
        switch credential?.realUserStatus {
        case .unsupported: realUserLabel.text = "Not supported on current platform (iOS only)"
        case .unknown: realUserLabel.text = "Unknown"
        case .likelyReal: realUserLabel.text = "Likely real"
        case .none: realUserLabel.text = "-"
        @unknown default: realUserLabel.text = "-"
        }
    }
}
