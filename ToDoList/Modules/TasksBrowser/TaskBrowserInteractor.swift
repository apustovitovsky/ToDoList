//
//  ItemListInteractor.swift
//  ToDoList
//

import Foundation

protocol TaskBrowserInteractorInput: AnyObject {
    func createNewTask()
    func updateItemList()
    func deleteTask(id: UUID)
    func toggleCompletion(id: UUID)
}

final class TaskBrowserInteractor {

    weak var presenter: TaskBrowserInteractorOutput?
    var entity: TaskBrowserEntity
    let service: TasksStorageService_Mock
    
    init(
        entity: TaskBrowserEntity,
        service: TasksStorageService_Mock) {
        self.entity = entity
        self.service = service
    }
}

extension TaskBrowserInteractor: TaskBrowserInteractorInput {
    
    func createNewTask() {
        let newTask = TaskItemEntity()
        entity.state = .creating
        entity.items.insert(newTask, at: 0)
        configure(with: entity)
        
        service.saveContext(entity.items) { [weak self] _ in
            guard let self else { return }
            self.entity.state = .normal
            self.configure(with: self.entity)
        }
        presenter?.editTask(newTask)
    }
    
    func updateItemList() {
        entity.state = .updating
        
        service.loadContext { [weak self] result in
            guard let self else { return }
            self.entity.state = .normal
            guard case .success(let tasks) = result else { return }
            self.entity.items = tasks
            self.configure(with: entity)
        }
        configure(with: entity)
    }
    
    func deleteTask(id: UUID) {
        entity.state = .deleting
        entity.items.removeAll{ $0.id == id }
        
        service.saveContext(entity.items) { [weak self] _ in
            guard let self else { return }
            self.entity.state = .normal
            self.configure(with: self.entity)
        }
        configure(with: entity)
    }
    
    func toggleCompletion(id: UUID) {
        if let index = entity.items.firstIndex(where: { $0.id == id }) {
            entity.items[index].isCompleted.toggle()

            service.saveContext(entity.items) { _ in
                print("saved")
            }
            
            configure(with: entity)
        }
    }
}

private extension TaskBrowserInteractor {
    func configure(with entity: TaskBrowserEntity) {
        presenter?.configure(with: entity)
    }
}

