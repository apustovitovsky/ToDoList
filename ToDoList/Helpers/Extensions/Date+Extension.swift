import Foundation

extension Date {
    static func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Resources.Strings.dateFormat
        return formatter.string(from: date)
    }
}
