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

struct TasksNetworkRequestDefault: NetworkRequest {

    typealias Response = TaskListResponse
    
    var endpoint: String = Resources.Strings.apiTodosEndpoint
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = .init()
    
    init(limit: Int) {
        queryItems = [
            URLQueryItem(name: Resources.Strings.apiQueryParamLimit, value: "\(limit)")
        ]
    }
}

struct RandomTasksNetworkRequest: NetworkRequest {

    typealias Response = [TaskItemResponse]
    
    var endpoint: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = .init()
    
    init(limit: Int) {
        endpoint = Resources.Strings.apiRandomTodosEndpoint + "/\(limit)"
    }
}

final class TaskNetworkService: NetworkService {
    
    static let shared: TaskNetworkService = .init()
    private init() {}
    
    let basePath: String = Resources.Strings.apiBasePath
    
    func fetchTasks(completion: @escaping ResultHandler<[TaskDetailsEntity]>) {
        try? send(request: RandomTasksNetworkRequest(limit: 2)) { result in
            switch result {
            case .success(let response):
                let tasks = response.map { TaskDetailsEntity(from: $0) }
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
