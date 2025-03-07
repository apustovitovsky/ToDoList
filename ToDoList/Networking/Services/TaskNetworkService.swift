import Foundation

protocol TaskNetworkServiceProtocol: NetworkService {
    func fetchTasks(count: Int, completion: @escaping ResultHandler<[TaskDetailsModel]>)
}

final class TaskNetworkService: TaskNetworkServiceProtocol {
    
    static let shared: TaskNetworkService = .init()
    private init() {}
    
    let basePath: String = Resources.Strings.apiBasePath
    
    func fetchTasks(count: Int, completion: @escaping ResultHandler<[TaskDetailsModel]>) {
        try? send(request: RandomTaskNetworkRequest(count: count)) { result in
            DispatchQueue.main.async {
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
}
