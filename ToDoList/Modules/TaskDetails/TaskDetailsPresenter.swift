protocol TaskDetailsPresenterInput: AnyObject {
    func moduleDidLoad()
    func titleDidChange(_ title: String)
    func contentDidChange(_ content: String)
}

protocol TaskDetailsInteractorOutput: AnyObject {
    func configure(with entity: TaskDetailsEntity)
}

final class TaskDetailsPresenter {
    weak var view: TaskDetailsPresenterOutput?
    private let interactor: TaskDetailsInteractorInput
    private let router: TaskDetailsModuleOutput
    
    init(
        router: TaskDetailsModuleOutput,
        interactor: TaskDetailsInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension TaskDetailsPresenter: TaskDetailsPresenterInput {
    func titleDidChange(_ title: String) {
        interactor.titleDidChange(title)
    }
    
    func contentDidChange(_ content: String) {
        interactor.contentDidChange(content)
    }
    
    func moduleDidLoad() {
        interactor.moduleDidLoad()
    }
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutput {
    func configure(with entity: TaskDetailsEntity) {
        view?.configure(with: entity)
    }
}
