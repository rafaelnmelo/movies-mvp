import UIKit

protocol MoviesDetailViewControllerDelegate: AnyObject {
    func favoriteMovie(index: Int)
}


class MovieDetailViewController: BaseViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePicture: UIImageView!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    private var presenter: MovieDetailPresenter?
    var delegate: MoviesDetailViewControllerDelegate?
    var index = 0
    var movieID: Int?
    var posterPath: String?
    var data: Movie?
    var favoriteList = [String:Dictionary<String, String>]()
    var list = UserDefaultsManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButtonTitle()
        setupPresenter()
        presenter?.getGenres()
        if presenter?.checkFav(data: data) == true {
            fillStarRightBar()
        } else {
            setupStarRightBar()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.favoriteMovie(index: self.index)
    }
}

//MARK: - FUNCTIONS

extension MovieDetailViewController {
    private func setupPresenter() {
        presenter = MovieDetailPresenter(movieData: data)
        presenter?.delegate = self
    }
    
    @objc func favorite(_ sender: Any) {
        if let movie = self.data {
            guard let fav = presenter?.buildFav(data: movie) else { return }
            
            if presenter?.checkFav(data: movie) == true {
                setupStarRightBar()
                list.removeFromFav(fav)
            } else {
                fillStarRightBar()
                list.addToFav(fav)
            }
        }

    }
}

extension MovieDetailViewController {
    struct Content {
        var picturePath: String?
        var overview: String?
        var releaseDate: String?
        var genres: [String]?
        var id: Int?
        var title: String?
        var posterPath: String?
    }

    func build(data: Movie?) {
        let url = URL(string: "\(Endpoint.fetchMoviePoster.rawValue)" + "\(data?.backdropPath ?? "")")
        
        self.moviePicture.kf.setImage(with: url)
        
        self.movieTitle.text = data?.originalTitle
        self.movieOverview.text = data?.overview
        self.movieReleaseDate.text = data?.releaseDate
        self.movieGenres.text = ""
        if let genres = presenter?.genres{
            for genreName in genres {
                if genreName == genres.last {
                    self.movieGenres.text?.append(" and \(genreName)")
                } else if genreName == genres.first {
                    self.movieGenres.text?.append("\(genreName)")
                } else {
                    self.movieGenres.text?.append(", \(genreName)")
                }
            }
        }
        self.posterPath = data?.posterPath
        self.movieID = data?.id
    }
    
    private func setupStarRightBar() {
        self.setRightBarButtonItem(imageName: "star",
                                   action: #selector(favorite))
    }
    
    private func fillStarRightBar() {
        self.setRightBarButtonItem(imageName: "starfill",
                                   action: #selector(favorite))
    }
}

//MARK: - PRESENTER DELEGATE
extension MovieDetailViewController: MoviesDetailPresenterDelegate {
    func fetchSuccess() {
        self.build(data: data)
    }
}



