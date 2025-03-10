import UIKit

final class TaskBrowserTableViewCell: UITableViewCell {
    
    static let identifier = "TasksViewCell"
    
    var model: TaskDetailsModel? {
        didSet {
            guard let model else { return }
            configure(with: model)
        }
    }
    var searchText: String = "" {
        didSet {
            applyFilterPrompt()
        }
    }

    lazy var checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Resources.Colors.tertiaryColor
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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

    func configure(with model: TaskDetailsModel) {
        let attributedTitle = NSMutableAttributedString(
            string: model.title.isEmpty ? Resources.Strings.titleEmptyTask : model.title,
            attributes: getTitleAttributes(for: model.isCompleted)
        )
        let attributedContent = NSMutableAttributedString(
            string: model.content,
            attributes: getContentAttributes(for: model.isCompleted)
        )
        dateLabel.text = Date.formatted(date: model.createdAt)
        
        checkboxImageView.image = model.isCompleted
            ? Resources.Images.taskCheckboxCompleted
            : Resources.Images.taskCheckbox
        
        checkboxImageView.tintColor = model.isCompleted
            ? Resources.Colors.accentColor
            : Resources.Colors.tertiaryColor
        
        titleLabel.attributedText = attributedTitle
        contentLabel.attributedText = attributedContent

        applyFilterPrompt()
    }
    
    func updateCheckbox(for isEnabled: Bool) {
        checkboxImageView.image = isEnabled ? Resources.Images.taskCheckboxCompleted : Resources.Images.taskCheckbox
        checkboxImageView.tintColor = isEnabled ? Resources.Colors.accentColor : Resources.Colors.tertiaryColor
    }
}

private extension TaskBrowserTableViewCell {
    
    private func applyFilterPrompt() {
        guard let model else { return }
        
        let attributedTitle = NSMutableAttributedString(
            string: model.title.isEmpty ? Resources.Strings.titleEmptyTask : model.title,
            attributes: getTitleAttributes(for: model.isCompleted)
        )
        let attributedContent = NSMutableAttributedString(
            string: model.content,
            attributes: getContentAttributes(for: model.isCompleted)
        )
        
        if !searchText.isEmpty {
            applyHighlight(to: attributedTitle, pattern: searchText)
            applyHighlight(to: attributedContent, pattern: searchText)
        }
        
        titleLabel.attributedText = attributedTitle
        contentLabel.attributedText = attributedContent
    }
    
    func setupIU() {
        backgroundColor = Resources.Colors.backgroundPrimary
        selectionStyle = .none
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
    
    func getTitleAttributes(for isCompleted: Bool) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if isCompleted {
            attributes[.foregroundColor] = Resources.Colors.secondaryColor
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        return attributes
    }
    
    func getContentAttributes(for isCompleted: Bool) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if isCompleted {
            attributes[.foregroundColor] = Resources.Colors.secondaryColor
        }
        return attributes
    }
    
    func applyHighlight(to attributedString: NSMutableAttributedString, pattern: String) {
        let fullText = attributedString.string.lowercased()
        var searchRange = NSRange(location: 0, length: fullText.utf16.count)

        while let range = fullText.range(of: pattern.lowercased(), options: [], range: Range(searchRange, in: fullText)) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .backgroundColor: Resources.Colors.accentColor,
                .foregroundColor: Resources.Colors.backgroundPrimary
            ], range: nsRange)
            searchRange = NSRange(location: nsRange.upperBound, length: fullText.utf16.count - nsRange.upperBound)
        }
    }
}
