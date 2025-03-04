import UIKit

final class TaskBrowserFooter: UIView {

    var onTaskCreateTap: Action?
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.primaryColor
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        return label
    }()
    
    private lazy var createTaskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.and.pencil")
        imageView.tintColor = Resources.Colors.secondaryColor
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskBrowserFooter {
    
    func toggleTaskCreationView(_ isActive: Bool) {
        createTaskImageView.tintColor = isActive ? Resources.Colors.accentColor : Resources.Colors.secondaryColor
        createTaskImageView.isUserInteractionEnabled = isActive
    }
    
    func updateCountLabel(items: [TaskDetailsModel]) {
        let completedItems = items.filter{ $0.isCompleted }
        progressLabel.text = !items.isEmpty ? "\(completedItems.count) of \(items.count) completed" : ""
    }
}

private extension TaskBrowserFooter {
    func setupLayout() {
        backgroundColor = Resources.Colors.backgroundSecondary
        
        addSubview(progressLabel)
        addSubview(createTaskImageView)
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        createTaskImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Constants.paddingMedium),
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            createTaskImageView.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Constants.paddingMedium),
            createTaskImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Constants.paddingLarge),
            createTaskImageView.widthAnchor.constraint(equalToConstant: Resources.Constants.checkboxSize),
            createTaskImageView.heightAnchor.constraint(equalToConstant: Resources.Constants.checkboxSize)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createTaskTapped))
        createTaskImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func createTaskTapped() {
        onTaskCreateTap?()
    }
}
