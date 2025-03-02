import Foundation

protocol NetworkService {
    var basePath: String { get }
    func send<T: NetworkRequest>(request: T, completion: @escaping ResultHandler<T.Response>) throws
}

extension NetworkService {
    func send<T: NetworkRequest>(request: T, completion: @escaping ResultHandler<T.Response>) throws {
        let urlRequest = try request.makeURLRequest(basePath: basePath)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data, let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let response = try request.makeResponse(from: data, urlResponse: urlResponse)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

