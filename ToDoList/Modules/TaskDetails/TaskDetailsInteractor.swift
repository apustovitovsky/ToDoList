protocol TaskDetailsInteractorInput: AnyObject {
    func moduleDidLoad()
    func titleDidChange(_: String)
    func contentDidChange(_: String)
    func editingDidFinish()
}

final class TaskDetailsInteractor {
    
    weak var presenter: TaskDetailsInteractorOutput?
    var model: TaskDetailsModel
    private let storageService: TaskStorageServiceProtocol
    
    init(model: TaskDetailsModel, storageService: TaskStorageServiceProtocol) {
        self.model = model
        self.storageService = storageService
    }
}

extension TaskDetailsInteractor: TaskDetailsInteractorInput {
    func editingDidFinish() {
        if model.title.isEmpty && model.content.isEmpty {
            storageService.deleteTask(with: model.id)
        } else {
            storageService.modifyTask(model)
        }
    }
    
    func titleDidChange(_ title: String) {
        model.title = title
    }
    
    func contentDidChange(_ content: String) {
        model.content = content
    }
    
    func moduleDidLoad() {
        presenter?.configure(with: model)
    }
}
