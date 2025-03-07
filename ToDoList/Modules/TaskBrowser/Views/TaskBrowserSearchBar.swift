import UIKit

final class TaskBrowserSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TaskBrowserSearchBar {

    func setupUI() {
        placeholder = Resources.Strings.searchBarPlaceholder
        barTintColor = .clear
        backgroundImage = UIImage()
        layer.cornerRadius = Resources.Constants.cornerRadius
        clipsToBounds = true
        searchTextField.backgroundColor = Resources.Colors.backgroundSecondary

        searchTextField.attributedPlaceholder = NSAttributedString(
            string: Resources.Strings.searchBarPlaceholder,
            attributes: [.foregroundColor: Resources.Colors.secondaryColor]
        )
        
        if let leftIconView = searchTextField.leftView as? UIImageView {
            leftIconView.tintColor = Resources.Colors.secondaryColor
        }
        if let rightIconView = searchTextField.rightView as? UIImageView {
            rightIconView.tintColor = Resources.Colors.secondaryColor
        }
    }
}

