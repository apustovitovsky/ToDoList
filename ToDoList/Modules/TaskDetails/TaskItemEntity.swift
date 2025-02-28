//
//  TaskItemEntity.swift
//  ToDoList
//

import Foundation

struct TaskItemEntity {
    let id: UUID
    var title: String
    var description: String
    let createdAt: Date
    var isCompleted: Bool
    
    init(title: String = "", description: String = "", isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.createdAt = Date()
        self.isCompleted = isCompleted
    }
}



