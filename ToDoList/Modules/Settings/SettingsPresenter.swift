import Foundation

protocol SettingsPresenterInput: AnyObject {
    func viewDidLoad()
    func didChangeTheme(to isDark: Bool)
}

protocol SettingsInteractorOutput: AnyObject {
    
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
        view?.updateTheme(isDark: ThemeProvider.shared.effectiveTheme == .dark)
    }
    
    func didChangeTheme(to isDark: Bool) {

    }
}

extension SettingsPresenter: SettingsInteractorOutput {
    
}
