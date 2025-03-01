//
//  TaskItemEntity.swift
//  ToDoList
//

import Foundation

struct TaskDetailsEntity {
    let id: UUID
    var title: String
    var content: String
    let createdAt: Date
    var isCompleted: Bool
    
    init(title: String = "", description: String = "", isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.content = description
        self.createdAt = Date()
        self.isCompleted = isCompleted
    }
}



