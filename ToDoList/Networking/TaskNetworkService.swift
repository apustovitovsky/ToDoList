import Foundation

final class TaskNetworkService: NetworkService {
    
    static let shared: TaskNetworkService = .init()
    private init() {}
    
    let basePath: String = Resources.Strings.apiBasePath
    
    func fetchTasks(completion: @escaping ResultHandler<[TaskDetailsModel]>) {
        try? send(request: RandomTaskNetworkRequest()) { result in
            switch result {
            case .success(let response):
                let tasks = response.map { TaskDetailsModel(from: $0) }
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
