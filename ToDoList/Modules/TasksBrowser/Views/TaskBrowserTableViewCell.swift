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

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 2
        label.textColor = Resources.Colors.white
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = Resources.Colors.lightGray
        return label
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Resources.Strings.dateFormat
        return formatter
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

    func configure(with task: TaskItemEntity) {
        titleLabel.text = !task.title.isEmpty ? task.title : Resources.Strings.titleNewTask
        descriptionLabel.text = task.description
        
        dateLabel.text = dateFormatter.string(from: task.createdAt)

        let isCompleted = task.isCompleted

        checkboxImageView.image = UIImage(systemName: isCompleted ? "checkmark.circle" : "circle")
        checkboxImageView.tintColor = isCompleted ? Resources.Colors.yellow : Resources.Colors.lightGray
        
        titleLabel.textColor = isCompleted ? Resources.Colors.lightGray : Resources.Colors.white
        descriptionLabel.textColor = titleLabel.textColor
        
        if let searchText = getSearchText?(), !searchText.isEmpty {
            updateHighlight(title: task.title, pattern: searchText)
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
        [titleLabel, descriptionLabel, dateLabel].forEach {
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
    
    func updateHighlight(title: String, pattern: String) {
        let attributedString = NSMutableAttributedString(string: title)
        var searchRange = NSRange(location: 0, length: title.utf16.count)
        
        while let range = title.lowercased().range(of: pattern, options: [], range: Range(searchRange, in: title)) {
            let nsRange = NSRange(range, in: title)
            attributedString.addAttribute(.backgroundColor, value: Resources.Colors.yellow, range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: Resources.Colors.black, range: nsRange)
            searchRange = NSRange(location: nsRange.location + nsRange.length, length: title.utf16.count - (nsRange.location + nsRange.length))
        }
        titleLabel.attributedText = attributedString
    }
}

