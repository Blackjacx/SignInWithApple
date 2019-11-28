import UIKit

final class RootViewController: UITableViewController {

    @IBAction func didPressSignOut(_ sender: Any) {
        GlobalState.performSignOut()
    }
}
