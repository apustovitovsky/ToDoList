import Foundation

protocol TaskBrowserInteractorInput: AnyObject {
    func addTask()
    func updateTasks()
    func deleteTask(_ model: TaskDetailsModel)
    func toggleCompletion(id: UUID)
}

final class TaskBrowserInteractor {

    weak var presenter: TaskBrowserInteractorOutput?
    var model: TaskBrowserModel
    private let storageManager = TaskPersistentService.shared
    private let networkService = TaskNetworkService.shared
    
    init(model: TaskBrowserModel) {
        self.model = model
    }
}

extension TaskBrowserInteractor: TaskBrowserInteractorInput {
    
    func addTask() {
        let newTask = TaskDetailsModel.createEmpty
        model.state = .creating
        configure(with: model)
        
        storageManager.createTasks([newTask]) { [weak self] in
            self?.updateTasks()
            self?.presenter?.editTask(newTask)
        }
    }
    
    func updateTasksFromNetwork() {
        networkService.fetchTasks { [weak self] result in
            guard let self = self, case .success(let tasks) = result else { return }
            storageManager.createTasks(tasks) {
                self.updateTasks()
            }
        }
    }
    
    func updateTasks() {
        model.state = .updating
        configure(with: model)
        
        storageManager.updateTasks { [weak self] result in
            guard let self = self, case .success(let tasks) = result else { return }
            self.model.state = .normal
            self.model.tasks = tasks
            self.configure(with: model)
            
            if tasks.isEmpty {
                self.updateTasksFromNetwork()
            }
        }
    }
    
    func deleteTask(_ task : TaskDetailsModel) {
        model.state = .deleting
        configure(with: model)
        
        storageManager.deleteTasks([task]) { [weak self] in
            self?.updateTasks()
        }
    }
    
    func toggleCompletion(id: UUID) {
        guard var task = model.tasks.first(where: { $0.id == id }) else { return }
        task.isCompleted.toggle()
        
        storageManager.modifyTasks([task]) { [weak self] in
            self?.updateTasks()
        }
    }
}

private extension TaskBrowserInteractor {
    func configure(with model: TaskBrowserModel) {
        presenter?.configure(with: model)
    }
}

