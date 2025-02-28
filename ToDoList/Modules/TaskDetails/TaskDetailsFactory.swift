//
//  TaskDetailsFactory.swift
//  ToDoList
//

import Foundation

struct TaskDetailsFactory: Factory {
    
    func build(with id: TaskItemEntity, _ completion: Handler<TaskDetailsRouterProtocol>? = nil) -> Presentable {
        let router = TaskDetailsRouter()
        let _ = TaskDetailsPresenter()
        let module = TaskDetailsView(with: id)
        completion?(router)
        
        return module
    }
}
