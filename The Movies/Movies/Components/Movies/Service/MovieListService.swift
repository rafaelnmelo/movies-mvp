import Foundation

final class MovieListService {
    
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func movieModelService(endpoint: String,
                           completionhandler: @escaping (Result<MovieListModel>) -> Void ) {
        
        self.networkManager.getFromServer(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let movieList = try JSONDecoder().decode(MovieListModel.self, from: data)
                    completionhandler(.success(movieList))
                } catch {
                    completionhandler(.failure(.decodeError))
                }
            case .failure:
                completionhandler(.failure(.badRequest))
            }
        }
    
    }
}
