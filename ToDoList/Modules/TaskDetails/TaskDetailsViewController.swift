import UIKit

protocol TaskDetailsPresenterOutput: AnyObject {
    func configure(with _: TaskDetailsModel)
}

final class TaskDetailsViewController: UIViewController {
    
    let presenter: TaskDetailsPresenterInput
    private lazy var customView = TaskDetailsView()
    
    init(presenter: TaskDetailsPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.editingDidFinish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        presenter.moduleDidLoad()
    }
}

extension TaskDetailsViewController: TaskDetailsPresenterOutput {
    func configure(with model: TaskDetailsModel) {
        customView.configure(with: model)
    }
}

extension TaskDetailsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == customView.titleTextField else { return }
        presenter.titleDidChange(textField.text ?? "")
    }
}

extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ contentView: UITextView) {
        guard contentView == customView.contentTextView else { return }
        presenter.contentDidChange(contentView.text)
    }
}

private extension TaskDetailsViewController {
    func setupDelegates() {
        customView.titleTextField.delegate = self
        customView.contentTextView.delegate = self
    }
}
