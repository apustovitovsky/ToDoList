protocol TaskDetailsInteractorInput: AnyObject {
    func moduleDidLoad()
    func titleDidChange(_ title: String)
    func contentDidChange(_ content: String)
}

final class TaskDetailsInteractor {
    weak var presenter: TaskDetailsInteractorOutput?
    var entity: TaskDetailsEntity
    let service = TaskManager.shared
    
    init(entity: TaskDetailsEntity) {
        self.entity = entity
    }
}

extension TaskDetailsInteractor: TaskDetailsInteractorInput {
    func titleDidChange(_ title: String) {
        entity.title = title
        service.modifyTasks([entity], completion: nil)
    }
    
    func contentDidChange(_ content: String) {
        entity.content = content
        service.modifyTasks([entity], completion: nil)
    }
    
    func moduleDidLoad() {
        presenter?.configure(with: entity)
    }
}
