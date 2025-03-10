import UIKit

enum Theme: Int {
    case light = 0
    case dark = 1
}

protocol ThemeProviderProtocol {

    var effectiveTheme: Theme { get }
    func setupTheme(to newTheme: Theme)
}

class ThemeProvider: ThemeProviderProtocol {

    static let themeDidChangeNotification = Notification.Name("themeDidChangeNotification")
    
    var effectiveTheme: Theme {
        return storedTheme ?? systemTheme ?? .light
    }
    
    private let themeKey = Resources.Strings.UserDefaults.themeKey
    
    private var storedTheme: Theme? {
        guard let storedValue = UserDefaults.standard.object(forKey: themeKey) as? Int else { return nil }
        return Theme(rawValue: storedValue)
    }
    
    private var systemTheme: Theme? {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .dark : .light
    }
    
    private func applyTheme() {
        NotificationCenter.default.post(name: ThemeProvider.themeDidChangeNotification, object: nil)
    }
    
    func setupTheme(to newTheme: Theme) {
 
        if newTheme != effectiveTheme {
            print(newTheme)
            UserDefaults.standard.set(newTheme.rawValue, forKey: themeKey)
            applyTheme()
        }
    }
    
    func resetTheme() {
        UserDefaults.standard.removeObject(forKey: themeKey)
        applyTheme()
    }
}
