//
//  TaskListService.swift
//  ToDoList
//

import Foundation

protocol TaskListServiceProtocol: AnyObject {
    func mockData(completion: @escaping Handler<[ItemListEntity.TaskItem]>)
}

final class TaskListService: TaskListServiceProtocol {
    func mockData(completion: @escaping ([ItemListEntity.TaskItem]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                completion([
                    .init(id: UUID(), title: "Some title 1", description: "Some description 1", createdAt: Date(), isCompleted: false),
                    .init(id: UUID(), title: "Some title 2", description: "Some description 2", createdAt: Date(), isCompleted: true),
                    .init(id: UUID(), title: "Some title 3", description: "Some description 3", createdAt: Date(), isCompleted: false)
                ])
            }
        }
    }
}

