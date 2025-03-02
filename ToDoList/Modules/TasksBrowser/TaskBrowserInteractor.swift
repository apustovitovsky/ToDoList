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
    private let storageManager = TaskStorageManager.shared
    private let networkService = TaskNetworkService.shared
    
    init(entity: TaskBrowserEntity) {
        self.entity = entity
    }
}

extension TaskBrowserInteractor: TaskBrowserInteractorInput {
    
    func addTask() {
        let newTask = TaskDetailsEntity()
        entity.state = .creating
        configure(with: entity)
        
        storageManager.createTasks([newTask]) { [weak self] in
            self?.updateTasks()
            self?.presenter?.editTask(newTask)
        }
    }
    
    func updateTasksFromNetwork() {
        networkService.fetchRandomTasks(count: 6) { [weak self] result in
            guard let self = self, case .success(let tasks) = result else { return }
            storageManager.createTasks(tasks) {
                self.updateTasks()
            }
        }
    }
    
    func updateTasks() {
        entity.state = .updating
        configure(with: entity)
        
        storageManager.updateTasks { [weak self] result in
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
        
        storageManager.deleteTasks([task]) { [weak self] in
            self?.updateTasks()
        }
    }
    
    func toggleCompletion(id: UUID) {
        guard var task = entity.items.first(where: { $0.id == id }) else { return }
        task.isCompleted.toggle()
        
        storageManager.modifyTasks([task]) { [weak self] in
            self?.updateTasks()
        }
    }
}

private extension TaskBrowserInteractor {
    func configure(with entity: TaskBrowserEntity) {
        presenter?.configure(with: entity)
    }
}

