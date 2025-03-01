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
    
    init(title: String = "", content: String = "", isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.isCompleted = isCompleted
    }
}



