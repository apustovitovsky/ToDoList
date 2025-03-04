import Foundation

struct TaskNetworkResponse: Decodable {
    let todo: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case todo, completed
    }
}

struct TaskContainerNetworkResponse: Decodable {
    let todos: [TaskNetworkResponse]
}




