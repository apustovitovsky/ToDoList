protocol TaskDetailsPresenterInput: AnyObject {
    func moduleDidLoad()
    func titleDidChange(_: String)
    func contentDidChange(_: String)
    func editingDidFinish()
}

protocol TaskDetailsInteractorOutput: AnyObject {
    func configure(with _: TaskDetailsModel)
}

final class TaskDetailsPresenter {
    weak var view: TaskDetailsPresenterOutput?
    private let router: TaskDetailsModuleOutput
    private let interactor: TaskDetailsInteractorInput
    
    init(
        router: TaskDetailsModuleOutput,
        interactor: TaskDetailsInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension TaskDetailsPresenter: TaskDetailsPresenterInput {
    func editingDidFinish() {
        interactor.editingDidFinish()
    }
    
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
    func configure(with model: TaskDetailsModel) {
        view?.configure(with: model)
    }
}
