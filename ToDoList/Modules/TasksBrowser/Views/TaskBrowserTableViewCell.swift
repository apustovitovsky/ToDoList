import UIKit

final class TaskBrowserTableViewCell: UITableViewCell {
    
    static let identifier = "TasksViewCell"

    var onCheckboxTapped: (() -> Void)?
    var getSearchText: (() -> String)?

    private lazy var checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Resources.Colors.lightGray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
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

    private lazy var contentLabel: UILabel = {
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupIU()
        setupSubviews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with task: TaskDetailsEntity) {
        let isCompleted = task.isCompleted

        let attributedTitle = NSMutableAttributedString(
            string: task.title.isEmpty ? Resources.Strings.titleEmptyTask : task.title,
            attributes: getAttributes(for: isCompleted, isTitle: true)
        )
        let attributedContent = NSMutableAttributedString(
            string: task.content,
            attributes: getAttributes(for: isCompleted, isTitle: false)
        )

        titleLabel.attributedText = attributedTitle
        contentLabel.attributedText = attributedContent

        dateLabel.text = Date.formatted(date: task.createdAt)
        checkboxImageView.image = UIImage(systemName: isCompleted ? "checkmark.circle" : "circle")
        checkboxImageView.tintColor = isCompleted ? Resources.Colors.yellow : Resources.Colors.lightGray

        if let searchText = getSearchText?(), !searchText.isEmpty {
            applyHighlight(to: attributedTitle, pattern: searchText)
            applyHighlight(to: attributedContent, pattern: searchText)

            titleLabel.attributedText = attributedTitle
            contentLabel.attributedText = attributedContent
        }
    }

    @objc private func checkboxTapped() {
        onCheckboxTapped?()
    }
}

private extension TaskBrowserTableViewCell {
    
    func setupIU() {
        backgroundColor = Resources.Colors.black
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func setupSubviews() {
        [checkboxImageView, stackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [titleLabel, contentLabel, dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkboxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Resources.Constants.paddingMedium),
            checkboxImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Resources.Constants.paddingMedium),
            checkboxImageView.widthAnchor.constraint(equalToConstant: Resources.Constants.checkboxSize),
            checkboxImageView.heightAnchor.constraint(equalToConstant: Resources.Constants.checkboxSize),
            stackView.leadingAnchor.constraint(equalTo: checkboxImageView.trailingAnchor, constant: Resources.Constants.paddingMedium),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Resources.Constants.paddingMedium),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Resources.Constants.paddingMedium),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Resources.Constants.paddingMedium)
        ])
    }
    
    func getAttributes(for isCompleted: Bool, isTitle: Bool) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if isCompleted {
            attributes[.foregroundColor] = Resources.Colors.lightGray
            if isTitle {
                attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            }
        }
        return attributes
    }
    
    func applyHighlight(to attributedString: NSMutableAttributedString, pattern: String) {
        let fullText = attributedString.string.lowercased()
        var searchRange = NSRange(location: 0, length: fullText.utf16.count)

        while let range = fullText.range(of: pattern.lowercased(), options: [], range: Range(searchRange, in: fullText)) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .backgroundColor: Resources.Colors.yellow,
                .foregroundColor: Resources.Colors.black
            ], range: nsRange)
            searchRange = NSRange(location: nsRange.upperBound, length: fullText.utf16.count - nsRange.upperBound)
        }
    }
}

