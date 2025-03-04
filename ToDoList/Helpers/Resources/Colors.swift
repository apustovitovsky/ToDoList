import UIKit


extension Resources {
    
    enum Colors {
        static let backgroundPrimary: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#040404")
                : UIColor(hex: "#1C1F28")
        }
        
        static let backgroundSecondary: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#1C1C1C")
                : UIColor(hex: "#262F3B")
        }
        
        static let primaryColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#FFFFFF")
                : UIColor(hex: "#E8E9F0")
        }
        
        static let secondaryColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#A0A0A0")
                : UIColor(hex: "#858FA3")
        }
        
        static let tertiaryColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#4F4F4F")
                : UIColor(hex: "#4D535E")
        }

        static let accentColor: UIColor = UIColor { traits in
            return traits.userInterfaceStyle == .dark
                ? UIColor(hex: "#F4BA42")
                : UIColor(hex: "#F4C153")
        }
    }
}
