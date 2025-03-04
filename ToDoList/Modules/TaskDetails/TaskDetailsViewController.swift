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
        setupHandlers()
        presenter.moduleDidLoad()
    }
}

extension TaskDetailsViewController: TaskDetailsPresenterOutput {
    func configure(with model: TaskDetailsModel) {
        customView.configure(with: model)
    }
}

private extension TaskDetailsViewController {
    func setupHandlers() {
        customView.handlers = .init(
            titleDidChange: { [weak self] title in
                self?.presenter.titleDidChange(title)
            },
            contentDidChange: { [weak self] content in
                self?.presenter.contentDidChange(content)
            }
        )
    }
}
