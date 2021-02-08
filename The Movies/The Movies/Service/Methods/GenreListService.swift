import Foundation

final class GenreListService {
    
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func genreModelService(endpoint: String,
                           completionhandler: @escaping (Result<GenreListModel>) -> Void ) {
        
        self.networkManager.getFromServer(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let genreListModel = try JSONDecoder().decode(GenreListModel.self, from: data)
                    completionhandler(.success(genreListModel))
                } catch {
                    completionhandler(.failure(.decodeError))
                }
            case .failure:
                completionhandler(.failure(.badRequest))
            }
        }
    
    }
}
