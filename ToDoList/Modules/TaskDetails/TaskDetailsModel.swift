import Foundation

struct TaskDetailsModel: Identifiable {
    let id: UUID
    var title: String
    var content: String
    let createdAt: Date
    var isCompleted: Bool
    
    static var createEmpty: Self {
        TaskDetailsModel(id: UUID(), title: "", content: "", createdAt: Date(), isCompleted: false)
    }
}

extension TaskDetailsModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension TaskDetailsModel {
    init(from response: TaskNetworkResponse) {
        self.id = UUID()
        self.title = response.todo
        self.content = ContentGenerator().generateSentense(wordCount: Int.random(in: 9..<12))
        self.createdAt = Date()
        self.isCompleted = response.completed
    }
}


