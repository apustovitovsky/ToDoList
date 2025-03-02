protocol TaskDetailsInteractorInput: AnyObject {
    func moduleDidLoad()
    func titleDidChange(_ title: String)
    func contentDidChange(_ content: String)
    func editingDidFinish()
}

final class TaskDetailsInteractor {
    weak var presenter: TaskDetailsInteractorOutput?
    var entity: TaskDetailsEntity
    let service = TaskStorageManager.shared
    
    init(entity: TaskDetailsEntity) {
        self.entity = entity
    }
}

extension TaskDetailsInteractor: TaskDetailsInteractorInput {
    func editingDidFinish() {
        service.modifyTasks([entity], completion: nil)
    }
    
    func titleDidChange(_ title: String) {
        entity.title = title
    }
    
    func contentDidChange(_ content: String) {
        entity.content = content
    }
    
    func moduleDidLoad() {
        presenter?.configure(with: entity)
    }
}
