import UIKit

protocol MoviesPresenterDelegate: AnyObject {
    func fetchSuccess()
    func fetchFailure()
}

class MoviesPresenter {
    
    private let movieService: MovieListService
    weak var delegate: MoviesPresenterDelegate?
    
    var movieData = [Movie]()
    var genres = [String]()
    
    init(movieService: MovieListService = MovieListService()) {
        self.movieService = movieService
    }
    
//MARK: - FUNCTIONS
    
    func getMoviesList() {
        self.movieService.movieModelService(endpoint: Endpoint.fetchMovieList.rawValue) { response in
            switch response {
            case .success(let movieModel):
                self.movieMapper(movieData: movieModel)
                self.delegate?.fetchSuccess()
                break
            case .failure:
                self.delegate?.fetchFailure()
                break
            }
        }
    }

}

//MARK: - OBJECT MAPPERS
extension MoviesPresenter {

    func movieMapper(movieData: MovieListModel) {
        self.movieData = movieData.results
    }
    
}

//MARK: - CELLS BUILDERS

extension MoviesPresenter {
    
    func numberOfMovieRows() -> Int{
        return movieData.count
    }
    
    func movieForRow(at indexPath: IndexPath) -> GenericCollectionViewCellController.Content{
        
        let data = GenericCollectionViewCellController.Content(
            posterPath: movieData[indexPath.row].posterPath,
            id: movieData[indexPath.row].id,
            title: movieData[indexPath.row].title)
        return data
    }
    
    func movieForDetail(at indexPath: IndexPath) -> Movie {
        return movieData[indexPath.row]
    }
    
}

