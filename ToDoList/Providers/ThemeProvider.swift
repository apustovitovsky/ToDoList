import UIKit

class ThemeProvider {
    
    enum Theme: Int {
        case light = 0
        case dark = 1
    }
    
    static let shared = ThemeProvider()
    
    private init() {}
    
    var effectiveTheme: Theme {
        return storedTheme ?? systemTheme ?? .light
    }
    
    private let themeKey = Resources.Strings.UserDefaults.themeKey
    
    private var storedTheme: Theme? {
        guard let storedValue = UserDefaults.standard.object(forKey: themeKey) as? Int else { return nil }
        return Theme(rawValue: storedValue)
    }
    
    private var systemTheme: Theme? {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first else { return nil }
        
        return window.traitCollection.userInterfaceStyle == .dark ? .dark : .light
    }
    
    func applyTheme() {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first else { return }
        
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) { [weak self] in
            guard let theme = self?.effectiveTheme else { return }
            window.overrideUserInterfaceStyle = theme == .dark ? .dark : .light
        }
    }
    
    func setupTheme(_ theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        applyTheme()
    }
    
    func resetTheme() {
        UserDefaults.standard.removeObject(forKey: themeKey)
        applyTheme()
    }
}
