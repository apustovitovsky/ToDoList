import Foundation

struct TaskItemResponse: Decodable {
    let todo: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case todo, completed
    }
}

struct TaskListResponse: Decodable {
    let todos: [TaskItemResponse]
}

extension TaskDetailsEntity {
    init(from response: TaskItemResponse) {
        self.id = UUID()
        self.title = response.todo
        self.content = SentenseGenerator().generateSentense(wordCount: Int.random(in: 9..<12))
        self.createdAt = Date()
        self.isCompleted = response.completed
    }
}

struct TaskNetworkRequest: NetworkRequest {

    typealias Response = TaskListResponse
    
    var endpoint: String = Resources.Strings.apiTodosEndpoint
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = .init()
    
    init(limit: Int = 254) {
        queryItems = [
            URLQueryItem(name: Resources.Strings.apiQueryParamLimit, value: "\(limit)")
        ]
    }
}

final class TaskNetworkService: NetworkService {
    
    static let shared: TaskNetworkService = .init()
    private init() {}
    
    let basePath: String = Resources.Strings.apiBasePath
    
    func fetchRandomTasks(count: Int = 5, completion: @escaping ResultHandler<[TaskDetailsEntity]>) {
        try? send(request: TaskNetworkRequest()) { result in
            switch result {
            case .success(let response):
                let tasks = response.todos
                    .shuffled()
                    .prefix(count)
                    .map { TaskDetailsEntity(from: $0) }
                
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
