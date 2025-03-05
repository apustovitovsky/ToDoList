protocol SettingsInteractorInput: AnyObject {
    func didChangeTheme(to _: Bool)
    func getEffectiveTheme() -> ThemeProvider.Theme
}

final class SettingsInteractor {
    
    weak var presenter: SettingsInteractorOutput?
    var model: SettingsModel
    private let themeProvider: ThemeProvider
    
    
    init(model: SettingsModel, themeProvider: ThemeProvider) {
        self.model = model
        self.themeProvider = themeProvider
    }
}

extension SettingsInteractor: SettingsInteractorInput {
    func getEffectiveTheme() -> ThemeProvider.Theme {
        themeProvider.effectiveTheme
    }
    
    func didChangeTheme(to isDarkMode: Bool) {
        themeProvider.setupTheme(isDarkMode ? .dark : .light)
    }
}

