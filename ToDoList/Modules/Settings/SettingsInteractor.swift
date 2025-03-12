import Foundation

protocol SettingsInteractorInput: AnyObject {
    func themeDidSelect(to _: Bool)
    func getEffectiveTheme() -> Theme
}

final class SettingsInteractor {
    
    weak var presenter: SettingsInteractorOutput?
    var model: SettingsModel
    private let themeProvider: ThemeProviderProtocol
    
    
    init(model: SettingsModel,
         themeProvider: ThemeProviderProtocol) {
        
        self.model = model
        self.themeProvider = themeProvider
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: ThemeProvider.themeDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func themeDidChange() {
        presenter?.updateTheme(isDark: themeProvider.effectiveTheme == .dark)
    }
}

extension SettingsInteractor: SettingsInteractorInput {
    func getEffectiveTheme() -> Theme {
        themeProvider.effectiveTheme
    }
    
    func themeDidSelect(to isDarkMode: Bool) {
        themeProvider.setupTheme(to: isDarkMode ? .dark : .light)
    }
}

