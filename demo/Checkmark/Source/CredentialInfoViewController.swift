import UIKit
import AuthenticationServices

final class CredentialInfoViewController: UIViewController {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var realUserLabel: UILabel!
    
    let credential: ASAuthorizationAppleIDCredential

    init(credential: ASAuthorizationAppleIDCredential) {
        self.credential = credential
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Unique, stable team-scoped user id
        // Stable across platforms and devices
        let userId = credential.user
        let email = credential.email
        let nameComponents = credential.fullName
        // Identity token and code can be exchanged for an access token from
        // your backend
        let identityToken = credential.identityToken
        let authCode = credential.authorizationCode
        // ASUserDetectionStatusUnsupported Not supported on current platform, ignore the value
        // ASUserDetectionStatusUnknown     We could not determine the value.
        //                                  New users in the ecosystem will get this value as well,
        //                                  so you should not blacklist but instead treat these users
        //                                  as any new user through standard email sign up flows.
        // ASUserDetectionStatusLikelyReal  A hint that we have high confidence that the user is real.
        let realUserStatus = credential.realUserStatus

        userIdLabel.text = userId
        givenNameLabel.text = nameComponents?.givenName
        familyNameLabel.text = nameComponents?.familyName
        emailLabel.text = email
        realUserLabel.text = "\(realUserStatus)"
    }
}
