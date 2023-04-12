import Alamofire

public enum Endpoint {
    case fetchMovieList
    case fetchGenreList
    case fetchMoviePoster
    
    var rawValue: String {
        switch self {
        case .fetchMovieList:
            return BaseURL.domain + "/movie/popular?api_key=1e4ba8bbb5c77a2861e8a23414ce6aed&language=pt-BR&page=1"
       case .fetchGenreList:
            return BaseURL.domain + "/genre/movie/list?api_key=1e4ba8bbb5c77a2861e8a23414ce6aed&language=pt-BR"
        case .fetchMoviePoster:
            return BaseURL.imageDomain + "/w300"
        }
    }
}

public struct BaseURL {
    static var domain = "https://api.themoviedb.org/3"
    static var imageDomain = "https://image.tmdb.org/t/p"
}
