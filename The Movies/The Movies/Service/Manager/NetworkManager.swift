import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func getFromServer( endpoint: String,
                        completionHandler: @escaping (Result<Data>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    var alamofire = Alamofire.Session()
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        alamofire = Alamofire.Session(configuration: configuration)
    }
    
    func getFromServer (endpoint: String,
                        completionHandler: @escaping (Result<Data>) -> Void) {
        if Reachability.isConnectedToInternet {
            alamofire.request(endpoint).validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completionHandler(.failure(.dataNotFound))
                        return
                    }
                    completionHandler(.success(data))
                case .failure:
                    completionHandler(.failure(.badRequest))
                }
            }
        } else {
            completionHandler(.failure(.internetError))
        }
    }
    
}
