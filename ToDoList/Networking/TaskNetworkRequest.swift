import Foundation

struct TaskNetworkRequest: NetworkRequest {

    typealias Response = TaskContainerNetworkResponse
    
    var endpoint: String = Resources.Strings.apiTodosEndpoint
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = .init()
    
    init(count: Int = 5) {
        queryItems = [
            URLQueryItem(name: Resources.Strings.apiQueryParamLimit, value: "\(count)")
        ]
    }
}

struct RandomTaskNetworkRequest: NetworkRequest {

    typealias Response = [TaskNetworkResponse]
    
    var endpoint: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = .init()
    
    init(count: Int = 5) {
        endpoint = Resources.Strings.apiRandomTodosEndpoint + "/\(count)"
    }
}

