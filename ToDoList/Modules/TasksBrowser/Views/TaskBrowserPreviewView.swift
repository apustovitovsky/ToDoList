import UIKit

final class TaskBrowserPreviewView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Resources.Constants.paddingSmall
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = Resources.Colors.primaryColor
        return label
    }()

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.textColor = Resources.Colors.primaryColor
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = Resources.Colors.secondaryColor
        return label
    }()
    
    init(with task: TaskDetailsModel) {
        super.init(frame: .zero)
        setupIU(with: task)
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TaskBrowserPreviewView {
    
    func setupIU(with task: TaskDetailsModel) {
        backgroundColor = Resources.Colors.backgroundSecondary
        layer.cornerRadius = Resources.Constants.cornerRadius
        clipsToBounds = true
        titleLabel.attributedText = NSAttributedString(
            string: !task.title.isEmpty ? task.title : Resources.Strings.titleEmptyTask,
            attributes: task.isCompleted ? [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ] : nil
        )
        contentLabel.text = task.content
        dateLabel.text = Date.formatted(date: task.createdAt)
    }
    
    func setupSubviews() {
        addSubview(stackView)
        [titleLabel, contentLabel, dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Constants.paddingMedium),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Constants.paddingMedium),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Constants.paddingMedium),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Resources.Constants.paddingMedium)
        ])
    }
}

