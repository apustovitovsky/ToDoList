import UIKit

protocol TaskBrowserPresenterOutput: AnyObject {
    func configure(with model: TaskBrowserModel)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.moduleDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension TaskBrowserViewController: TaskBrowserPresenterOutput {
    func configure(with model: TaskBrowserModel) {
        customView.configure(with: model)
    }
}

private extension TaskBrowserViewController {
    
    private func setupNavigationBar() {
        title = Resources.Strings.taskBrowserTitle
        let gearImage = UIImage(systemName: "gearshape")
        let settingsButton = UIBarButtonItem(
            image: gearImage,
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }

    @objc private func settingsButtonTapped() {
        presenter.settingsTapped()
    }
    
    func setupHandlers() {
        customView.handlers = .init(
            createTask: { [weak self] in
                self?.presenter.createTask()
            },
            editTask: { [weak self] task in
                self?.presenter.editTask(task)
            },
            deleteTask: { [weak self] task in
                self?.presenter.deleteTask(task)
            },
            toggleCompletion: { [weak self] id in
                self?.presenter.toggleCompletion(id: id)
            }
        )
    }
}



