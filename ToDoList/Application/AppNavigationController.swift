import UIKit

final class AppNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension AppNavigationController {
    func setupUI() {
        navigationBar.tintColor = Resources.Colors.accentColor

    }
}


