import UIKit

final class TaskDetailsView: UIView {
    
    struct Handlers {
        var titleDidChange: Handler<String>
        var contentDidChange: Handler<String>
    }
    
    var handlers: Handlers?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = Resources.Colors.white
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.returnKeyType = .done
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = Resources.Colors.white
        textView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textView.backgroundColor = .clear
        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupSubviews()
        setupConstraints()
        setupDelegates()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with entity: TaskDetailsEntity) {
        titleTextField.text = entity.title
        dateLabel.text = Date.formatted(date: entity.createdAt)
        contentTextView.text = entity.content
    }
}

private extension TaskDetailsView {
    
    func setupDelegates() {
        titleTextField.delegate = self
        contentTextView.delegate = self
    }
    
    func setupUI() {
        backgroundColor = Resources.Colors.black
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
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: Resources.Constants.paddingMedium),
            dateLabel.leftAnchor.constraint(equalTo: titleTextField.leftAnchor),
            
            contentTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Resources.Constants.paddingMedium),
            contentTextView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor),
            contentTextView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Resources.Constants.paddingMedium)
        ])
    }
}

extension TaskDetailsView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == titleTextField else { return }
        handlers?.titleDidChange(textField.text ?? "")
    }
}

extension TaskDetailsView: UITextViewDelegate {
    func textViewDidChange(_ contentView: UITextView) {
        guard contentView == contentTextView else { return }
        handlers?.contentDidChange(contentView.text)
    }
}


