import UIKit

final class TaskDetailsView: UIView {
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Resources.Colors.primaryColor
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.attributedPlaceholder = NSAttributedString(
            string: Resources.Strings.titlePlaceholder,
            attributes: [
                .foregroundColor: Resources.Colors.backgroundSecondary,
                .font: UIFont.systemFont(ofSize: 34)
            ])
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.secondaryColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = Resources.Colors.primaryColor
        textView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textView.backgroundColor = .clear
        return textView
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
    
    func configure(with model: TaskDetailsModel) {
        titleTextField.text = model.title
        dateLabel.text = Date.formatted(date: model.createdAt)
        contentTextView.text = model.content
    }
}

private extension TaskDetailsView {
    
    func setupUI() {
        backgroundColor = Resources.Colors.backgroundPrimary
    }
    
    func setupSubviews() {
        addSubview(titleTextField)
        addSubview(dateLabel)
        addSubview(contentTextView)
    }
    
    func setupConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Resources.Constants.paddingMedium),
            titleTextField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: Resources.Constants.paddingMedium),
            titleTextField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -Resources.Constants.paddingMedium),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Resources.Constants.paddingLarge),
            dateLabel.leftAnchor.constraint(equalTo: titleTextField.leftAnchor),
            
            contentTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Resources.Constants.paddingMedium),
            contentTextView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor),
            contentTextView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Resources.Constants.paddingMedium)
        ])
    }
}



