import Foundation
import CoreData

final class TaskPersistentService {

    static let shared: TaskPersistentService = .init()
    private init() {}
    lazy var container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores{ _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func createTasks(_ tasks: [TaskDetailsModel], completion: Action?) {
        container.performBackgroundTask { context in
            tasks.forEach { task in
                TaskEntity(context: context).update(by: task)
            }
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func updateTasks(completion: @escaping ResultHandler<[TaskDetailsModel]>) {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            do {
                let tasks = try context.fetch(request).map { $0.toModel() }
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func modifyTasks(_ tasks: [TaskDetailsModel], completion: Action?) {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            let ids = tasks.map { $0.id }
            request.predicate = NSPredicate(format: "id IN %@", ids as CVarArg)
            do {
                let results = try context.fetch(request)
                for existingTask in results {
                    if let updatedTask = tasks.first(where: { $0.id == existingTask.id }) {
                        existingTask.title = updatedTask.title
                        existingTask.content = updatedTask.content
                        existingTask.isCompleted = updatedTask.isCompleted
                    }
                }
                try context.save()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func deleteTasks(_ tasks: [TaskDetailsModel], completion: Action?) {
        container.performBackgroundTask { context in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            let ids = tasks.map { $0.id }
            request.predicate = NSPredicate(format: "id IN %@", ids as CVarArg)
            do {
                let results = try context.fetch(request)
                results.forEach { context.delete($0) }
                try context.save()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}


