import UIKit

final class TaskBrowserTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TaskBrowserTableView {
    
    func setupUI() {
        backgroundColor = Resources.Colors.backgroundPrimary
        keyboardDismissMode = .onDrag
        separatorStyle = .singleLine
        separatorColor = Resources.Colors.tertiaryColor
        separatorInset = UIEdgeInsets(
            top: 0,
            left: Resources.Constants.paddingMedium,
            bottom: 0,
            right: Resources.Constants.paddingMedium
        )
    }
}
