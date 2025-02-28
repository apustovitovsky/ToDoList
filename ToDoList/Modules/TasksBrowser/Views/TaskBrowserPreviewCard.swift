//
//  TaskBrowserPreview.swift
//  ToDoList
//

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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Resources.Strings.dateFormat
        return formatter
    }()
    
    init(title: String, description: String, createdAt: Date) {
        super.init(frame: .zero)
        setupIU(title: title, description: description, createdAt: createdAt)
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TaskBrowserPreviewCard {
    
    func setupIU(title: String, description: String, createdAt: Date) {
        backgroundColor = Resources.Colors.gray
        layer.cornerRadius = Resources.Constants.cornerRadius
        clipsToBounds = true
        titleLabel.text = !title.isEmpty ? title : Resources.Strings.titleNewTask
        descriptionLabel.text = description
        dateLabel.text = dateFormatter.string(from: createdAt)
        
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

