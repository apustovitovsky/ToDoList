import Foundation

struct TaskNetworkRequest: NetworkRequest {

    typealias Response = TaskContainerNetworkResponse
    
    var endpoint: String = Resources.Strings.apiTodosEndpoint
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = .init()
    
    init(limit: Int) {
        queryItems = [
            URLQueryItem(name: Resources.Strings.apiQueryParamLimit, value: "\(limit)")
        ]
    }
}

struct RandomTaskNetworkRequest: NetworkRequest {

    typealias Response = [TaskNetworkResponse]
    
    var endpoint: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem]? = .init()
    
    init(limit: Int = 4) {
        endpoint = Resources.Strings.apiRandomTodosEndpoint + "/\(limit)"
    }
}

