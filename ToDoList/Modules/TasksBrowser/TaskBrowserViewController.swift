import UIKit

protocol TaskBrowserPresenterOutput: AnyObject {
    func configure(with entity: TaskBrowserEntity)
}

final class TaskBrowserViewController: UIViewController {
    
    let presenter: TaskBrowserPresenterInput
    private lazy var customView = TaskBrowserView(presenter: presenter)
    
    init(presenter: TaskBrowserPresenterInput) {
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
        presenter.updateEntity()
    }
}

extension TaskBrowserViewController: TaskBrowserPresenterOutput {
    func configure(with entity: TaskBrowserEntity) {
        customView.configure(with: entity)
    }
}



