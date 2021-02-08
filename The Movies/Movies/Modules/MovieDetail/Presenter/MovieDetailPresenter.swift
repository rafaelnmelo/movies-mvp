import UIKit

protocol MoviesDetailPresenterDelegate: AnyObject {
    func fetchSuccess()
}

class MovieDetailPresenter {
    
    private let genreService: GenreListService
    
    var delegate: MoviesDetailPresenterDelegate?
    var genreData = [Genre]()
    var genres = [String]()
    var movieData: Movie?
    
    var favorite = [String:Dictionary<String, String>]()
    var list = UserDefaultsManager.shared
    
    init(genreService: GenreListService = GenreListService(), movieData: Movie?) {
        self.genreService = genreService
        self.movieData = movieData
    }
    
//MARK: - FUNCTIONS
    
    func getGenres() {
        self.genreService.genreModelService(endpoint: Endpoint.fetchGenreList.rawValue) { response in
            switch response {
            case .success(let genreModel):
                self.genreMapper(genreData: genreModel)
                self.delegate?.fetchSuccess()
                break
            case .failure:
                break
            }
        }
    }

}

//MARK: - OBJECT MAPPERS
extension MovieDetailPresenter {
    
    func genreMapper(genreData: GenreListModel) {
        self.genreData = genreData.genres
        
        self.genres = []
        
        if let movieGenres = movieData?.genreIds {
            for genre in self.genreData {
                for id in movieGenres {
                    if id == genre.id {
                        self.genres.append(genre.name)
                    }
                }
            }
        }
    }
    
}

//MARK: - CELLS BUILDERS

extension MovieDetailPresenter {
    
    func movieDetail(at indexPath: IndexPath) -> MovieDetailViewController.Content{
        
        let data = MovieDetailViewController.Content(
            picturePath: movieData?.backdropPath,
            overview: movieData?.overview,
            releaseDate: movieData?.releaseDate,
            genres: self.genres,
            id: movieData?.id,
            title: movieData?.title,
            posterPath: movieData?.posterPath)
        return data
    }
    
}

//MARK: - FAVORITES MANAGEMENT

extension MovieDetailPresenter {
    
    func checkFav(data: Movie?) -> Bool {
        let userDefaults = UserDefaults.standard
        let favoritesList = userDefaults.object(forKey: "favoritesList") as? [String:Dictionary<String, String>] ?? [:]
        
        var result = false
        
        for item in favoritesList {
            for subItem in item.value {
                if subItem.value == "\(data?.id ?? 0)" {
                    result = true
                }
            }
        }
        
        return result
    }
    
    func buildFav(data: Movie?) -> [String:Dictionary<String, String>]{
        var content = [String:String]()
        
        content["id"] = "\(data?.id ?? 0)"
        content["picturePath"] = data?.backdropPath
        content["overview"] = data?.overview
        content["releaseDate"] = data?.releaseDate
        content["title"] = data?.title
        content["posterPath"] = data?.posterPath
        
        var fav = [String:Dictionary<String, String>]()
        fav["\(data?.id ?? 0)"] = content
        return fav
    }
    
}


