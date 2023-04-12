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
        
        self.printRequest(headers: nil, params: nil, method: HTTPMethod.get.rawValue, urlRequest: endpoint)
        
        if Reachability.isConnectedToInternet {
            alamofire.request(endpoint).validate().responseJSON { response in
                self.printResponse(response: response)
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

//MARK: - PRINT -
extension NetworkManager {
    private func printRequest(headers: [String: String]?, params: [String:Any]? = nil, method: String, urlRequest: String? = nil){
        debugPrint("----------------- REQUEST ---------------------", terminator: "\n\n")
        debugPrint("\(method): \(urlRequest ?? "")")
        debugPrint("headers:")
        if let headers = headers {
            for (key,value) in headers {
                debugPrint("\(key) = \(value)")
            }
        }
        if let params = params {
            debugPrint("-------- PARAMETERS --------")
            for (key,value) in params {
                debugPrint("\(key) = \(value)")
            }
        }
        debugPrint("------------------------------------------------", terminator: "\n\n")
        
    }
    
    private func printResponse(response:AFDataResponse<Any>){
        debugPrint("----------------- RESPONSE ---------------------", terminator: "\n\n")
        debugPrint("Request for \(response.response?.url?.absoluteString ?? "-sem url-") completed with status code \(response.response?.statusCode ?? 0)")
        debugPrint("headers:")
        if let headers = response.response?.allHeaderFields {
            for (key,value) in headers {
                debugPrint("\(key) = \(value)")
            }
        }
        
        guard let data = response.data else { return }
        
        if data.count > 0 {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    debugPrint("data:")
                    for dict in json {
                        NSLog("\(dict.key) : \(dict.value)")
                    }
                }
            } catch {
                if let str = String(data: data, encoding: .utf8) {
                    NSLog(str)
                } else {
                    debugPrint("JSON parse error")
                }
            }
            
        }
        debugPrint("------------------------------------------------", terminator: "\n\n")
    }
    
}
