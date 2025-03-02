import Foundation

protocol NetworkRequest {
    associatedtype Response
    
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    
    func makeURLRequest(basePath: String) throws -> URLRequest
    func makeResponse(from data: Data, urlResponse: HTTPURLResponse) throws -> Response
}

extension NetworkRequest where Response: Decodable {
    func makeResponse(from data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

extension NetworkRequest {
    func makeURLRequest(basePath: String) throws -> URLRequest {
        guard
            var urlComponents = URLComponents(string: basePath + endpoint) else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = queryItems
        guard let finalURL = urlComponents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        return request
    }
}
