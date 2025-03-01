protocol TaskDetailsInteractorInput: AnyObject {
    func moduleDidLoad()
    func titleDidChange(_ title: String)
    func contentDidChange(_ content: String)
}

final class TaskDetailsInteractor {
    weak var presenter: TaskDetailsInteractorOutput?
    var entity: TaskDetailsEntity
    let service: TasksStorageService_Mock
    
    init(
        entity: TaskDetailsEntity,
        service: TasksStorageService_Mock) {
        self.entity = entity
        self.service = service
    }
}

extension TaskDetailsInteractor: TaskDetailsInteractorInput {
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
