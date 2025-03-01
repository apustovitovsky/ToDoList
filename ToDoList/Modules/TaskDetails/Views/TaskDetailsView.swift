import UIKit

final class TaskDetailsView: UIView {
    
    struct Handlers {
        var titleDidChange: Handler<String>
        var contentDidChange: Handler<String>
    }
    
    var hanlers: Handlers?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with entity: TaskDetailsEntity) {
        titleLabel.text = entity.title
        dateLabel.text = Date.formatted(date: entity.createdAt)
        contentLabel.text = entity.content
    }
}

private extension TaskDetailsView {
    
    func setupUI() {
        backgroundColor = Resources.Colors.black
    }
    
    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(contentLabel)
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Resources.Constants.paddingMedium),
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Resources.Constants.paddingSmall),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Resources.Constants.paddingMedium),
            dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Resources.Constants.paddingMedium),
            contentLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
        ])
    }
}

