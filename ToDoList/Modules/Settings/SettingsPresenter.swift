import Foundation

protocol SettingsPresenterInput: AnyObject {
    func viewDidLoad()
    func didChangeTheme(to _: Bool)
}

protocol SettingsInteractorOutput: AnyObject {
    func updateTheme(isDark: Bool)
}

final class SettingsPresenter {
    
    weak var view: SettingsPresenterOutput?
    private let router: SettingsModuleOutput
    private let interactor: SettingsInteractorInput
    
    init(
        router: SettingsModuleOutput,
        interactor: SettingsInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension SettingsPresenter: SettingsPresenterInput {
    
    func viewDidLoad() {
        view?.updateTheme(isDark: interactor.getEffectiveTheme() == .dark)
    }
    
    func didChangeTheme(to isDarkMode: Bool) {
        interactor.themeDidSelect(to: isDarkMode)
    }
}

extension SettingsPresenter: SettingsInteractorOutput {
    func updateTheme(isDark: Bool) {
        view?.updateTheme(isDark: isDark)
    }
}
