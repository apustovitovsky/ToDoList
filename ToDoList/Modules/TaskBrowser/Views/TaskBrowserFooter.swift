import UIKit

final class TaskBrowserFooter: UIView {

    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.primaryColor
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        return label
    }()
    
    lazy var taskCreationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Resources.Images.createTask
        imageView.tintColor = Resources.Colors.secondaryColor
        return imageView
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
}

extension TaskBrowserFooter {
    
    func setCreationEnabled(_ isEnabled: Bool) {
        taskCreationImage.tintColor = isEnabled ? Resources.Colors.accentColor : Resources.Colors.secondaryColor
        taskCreationImage.isUserInteractionEnabled = isEnabled
    }
    
    func updateProgressLabel(countCompleted: Int, countTotal: Int) {
        progressLabel.text = countTotal > 0 ? "\(countCompleted) of \(countTotal) completed" : ""
    }
}

private extension TaskBrowserFooter {
    
    func setupUI() {
        backgroundColor = Resources.Colors.backgroundSecondary
    }
    
    func setupSubviews() {
        addSubview(progressLabel)
        addSubview(taskCreationImage)
    }
    
    func setupConstraints() {
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCreationImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Constants.paddingMedium),
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            taskCreationImage.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Constants.paddingMedium),
            taskCreationImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Constants.paddingLarge),
            taskCreationImage.widthAnchor.constraint(equalToConstant: Resources.Constants.checkboxSize),
            taskCreationImage.heightAnchor.constraint(equalToConstant: Resources.Constants.checkboxSize)
        ])
    }
    

}
