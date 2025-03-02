import Foundation

protocol TaskBrowserInteractorInput: AnyObject {
    func addTask()
    func updateTasks()
    func deleteTask(_ task: TaskDetailsEntity)
    func toggleCompletion(id: UUID)
}

final class TaskBrowserInteractor {

    weak var presenter: TaskBrowserInteractorOutput?
    var entity: TaskBrowserEntity
    private let storageService = TaskManager.shared
    private let networkService = TasksStorageService_Mock.shared
    
    init(entity: TaskBrowserEntity) {
        self.entity = entity
    }
}

extension TaskBrowserInteractor: TaskBrowserInteractorInput {
    
    func addTask() {
        let newTasks = [TaskDetailsEntity()]
        entity.state = .creating
        configure(with: entity)
        
        storageService.createTasks(newTasks) { [weak self] in
            self?.updateTasks()
            //self.presenter?.editTask(task)
        }
    }
    
    func updateTasksFromNetwork() {
        networkService.loadContext { [weak self] result in
            guard let self = self, case .success(let tasks) = result else { return }
            storageService.createTasks(tasks) {
                self.updateTasks()
            }
        }
    }
    
    func updateTasks() {
        entity.state = .updating
        configure(with: entity)
        
        storageService.updateTasks { [weak self] result in
            guard let self = self, case .success(let tasks) = result else { return }
            self.entity.state = .normal
            self.entity.items = tasks
            self.configure(with: entity)
            
            if tasks.isEmpty {
                self.updateTasksFromNetwork()
            }
        }
    }
    
    func deleteTask(_ task : TaskDetailsEntity) {
        entity.state = .deleting
        configure(with: entity)
        
        storageService.deleteTasks([task]) { [weak self] in
            self?.updateTasks()
        }
    }
    
    func toggleCompletion(id: UUID) {
        guard var task = entity.items.first(where: { $0.id == id }) else { return }
        task.isCompleted.toggle()
        
        storageService.modifyTasks([task]) { [weak self] in
            self?.updateTasks()
        }
    }
}

private extension TaskBrowserInteractor {
    func configure(with entity: TaskBrowserEntity) {
        presenter?.configure(with: entity)
    }
}

