import UIKit

final class TaskBrowserPreviewCard: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Resources.Constants.paddingSmall
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = Resources.Colors.white
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.textColor = Resources.Colors.white
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = Resources.Colors.lightGray
        return label
    }()
    
    init(with task: TaskDetailsEntity) {
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

private extension TaskBrowserPreviewCard {
    
    func setupIU(with task: TaskDetailsEntity) {
        backgroundColor = Resources.Colors.gray
        layer.cornerRadius = Resources.Constants.cornerRadius
        clipsToBounds = true
        titleLabel.attributedText = NSAttributedString(
            string: !task.title.isEmpty ? task.title : Resources.Strings.titleNewTask,
            attributes: task.isCompleted ? [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ] : nil
        )
        descriptionLabel.text = task.content
        dateLabel.text = Date.formatted(date: task.createdAt)
    }
    
    func setupSubviews() {
        addSubview(stackView)
        [titleLabel, descriptionLabel, dateLabel].forEach {
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

