import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        guard hexSanitized.count == 6, let hexNumber = Int(hexSanitized, radix: 16) else {
            self.init(white: 0.0, alpha: alpha)
            return
        }

        let r = CGFloat((hexNumber >> 16) & 0xFF) / 255.0
        let g = CGFloat((hexNumber >> 8) & 0xFF) / 255.0
        let b = CGFloat(hexNumber & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}


