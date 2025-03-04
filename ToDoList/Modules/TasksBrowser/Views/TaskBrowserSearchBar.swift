import UIKit

final class TaskBrowserSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TaskBrowserSearchBar {
    
    func setupLayout() {
        placeholder = Resources.Strings.searchBarPlaceholder
        barTintColor = .clear
        backgroundImage = UIImage()
        layer.cornerRadius = Resources.Constants.cornerRadius
        clipsToBounds = true
        searchTextField.backgroundColor = Resources.Colors.backgroundSecondary
//        searchTextField.textColor = Resources.Colors.lightGray

        searchTextField.attributedPlaceholder = NSAttributedString(
            string: Resources.Strings.searchBarPlaceholder,
            attributes: [.foregroundColor: Resources.Colors.secondaryColor]
        )
        
        if let leftIconView = searchTextField.leftView as? UIImageView {
            leftIconView.tintColor = Resources.Colors.secondaryColor
        }
    }
}

