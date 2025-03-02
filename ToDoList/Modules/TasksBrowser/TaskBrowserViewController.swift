import UIKit

protocol TaskBrowserPresenterOutput: AnyObject {
    func configure(with entity: TaskBrowserEntity)
}

final class TaskBrowserViewController: UIViewController {
    
    let presenter: TaskBrowserPresenterInput
    private lazy var customView = TaskBrowserView()
    
    init(presenter: TaskBrowserPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupHandlers()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter.moduleDidAppear()
    }
}

extension TaskBrowserViewController: TaskBrowserPresenterOutput {
    func configure(with entity: TaskBrowserEntity) {
        customView.configure(with: entity)
    }
}

private extension TaskBrowserViewController {
    func setupHandlers() {
        customView.handlers = .init(
            createTask: { [weak self] in
                self?.presenter.createTask()
            },
            editTask: { [weak self] in
                self?.presenter.editTask($0)
            },
            deleteTask: { [weak self] in
                self?.presenter.deleteTask($0)
            },
            toggleCompletion: { [weak self] in
                self?.presenter.toggleCompletion(id: $0)
            }
        )
    }
}



