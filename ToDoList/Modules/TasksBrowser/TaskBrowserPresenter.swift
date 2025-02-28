//
//  ItemListPresenter.swift
//  ToDoList
//

import Foundation

protocol TaskBrowserPresenterInput: AnyObject {
    func updateEntity()
    func createNewTask()
    func editTask(_ task: TaskItemEntity)
    func deleteTask(id: UUID)
    func toggleCompletion(id: UUID)
}

protocol TaskBrowserInteractorOutput: AnyObject {
    func configure(with entity: TaskBrowserEntity)
    func editTask(_ task: TaskItemEntity)
}

final class TaskBrowserPresenter {

    weak var view: TaskBrowserPresenterOutput?
    private let interactor: TaskBrowserInteractorInput
    private let router: TaskBrowserModuleOutput
    
    init(
        router: TaskBrowserModuleOutput,
        interactor: TaskBrowserInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension TaskBrowserPresenter: TaskBrowserPresenterInput {
    
    func createNewTask() {
        interactor.createNewTask()
    }
    
    func toggleCompletion(id: UUID) {
        interactor.toggleCompletion(id: id)
    }
    
    func updateEntity() {
        interactor.updateItemList()
    }
    
    func editTask(_ task: TaskItemEntity) {
        router.showTaskDetails?(task)
    }
    
    func deleteTask(id: UUID) {
        interactor.deleteTask(id: id)
    }
}

extension TaskBrowserPresenter: TaskBrowserInteractorOutput {
    func configure(with entity: TaskBrowserEntity) {
        view?.configure(with: entity)
    }
}

