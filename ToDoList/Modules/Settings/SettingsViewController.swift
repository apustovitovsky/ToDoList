import UIKit

protocol SettingsPresenterOutput: AnyObject {
    func updateTheme(isDark: Bool)
}

final class SettingsViewController: UIViewController {
    
    private let presenter: SettingsPresenterInput
    private lazy var customView = SettingsView()
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Resources.Strings.settingsTitle
        customView.themeSwitch.addTarget(self, action: #selector(didToggleTheme), for: .valueChanged)
        presenter.viewDidLoad()
    }
    
    init(presenter: SettingsPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

private extension SettingsViewController {
    @objc private func didToggleTheme() {
        presenter.didChangeTheme(to: customView.themeSwitch.isOn)
    }
}

extension SettingsViewController: SettingsPresenterOutput {
    func updateTheme(isDark: Bool) {
        customView.themeSwitch.isOn = isDark
    }
}

