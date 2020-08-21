import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!

    override func viewDidLoad() {
        title = "Home"

        btnLogout.layer.cornerRadius = 8
        btnLogout.clipsToBounds = true
    }

    @IBAction func didLogout(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else { return }
        Cache.shared.clear()

        let rootVC = LoginViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navVC
    }
}
