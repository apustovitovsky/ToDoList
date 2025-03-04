protocol TaskDetailsInteractorInput: AnyObject {
    func moduleDidLoad()
    func titleDidChange(_: String)
    func contentDidChange(_: String)
    func editingDidFinish()
}

final class TaskDetailsInteractor {
    weak var presenter: TaskDetailsInteractorOutput?
    var model: TaskDetailsModel
    let service = TaskStorageManager.shared
    
    init(model: TaskDetailsModel) {
        self.model = model
    }
}

extension TaskDetailsInteractor: TaskDetailsInteractorInput {
    func editingDidFinish() {
        service.modifyTasks([model], completion: nil)
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
