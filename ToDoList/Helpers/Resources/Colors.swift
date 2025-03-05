import UIKit


extension Resources {
    
    enum Colors {
        static let backgroundPrimary: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#040404")
                : UIColor(hex: "#FFFFFF")
        }
        
        static let backgroundSecondary: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#1C1C1C")
                : UIColor(hex: "#F2F2F2")
        }
        
        static let primaryColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#FFFFFF")
                : UIColor(hex: "#000000")
        }
        
        static let secondaryColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#A0A0A0")
                : UIColor(hex: "#6C7278")
        }
        
        static let tertiaryColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#4F4F4F")
                : UIColor(hex: "#9C9C9C")
        }

        static let accentColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#F4BA42")
                : UIColor(hex: "#3C83FF")
        }
    }
}
