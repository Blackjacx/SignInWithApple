import UIKit

enum Constants {

    static let raster: CGFloat = 11.0
    
    static var signInViewController: SignInViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vcId = Constants.Keys.signInViewControllerStoryboardId
        return board.instantiateViewController(withIdentifier: vcId) as! SignInViewController
    }

    enum Keys {
        static let userId = "USER-ID"
        static let signInViewControllerStoryboardId = "SignInViewController"
    }
}
