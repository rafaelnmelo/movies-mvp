import UIKit
import Kingfisher

class GenericCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak private var moviePoster: UIImageView!
    @IBOutlet weak private var movieTitle: UILabel!
    @IBOutlet weak private var favoriteStar: UIImageView!
    private var movieID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkFav(data: movieID ?? "")
    }
    
}

extension GenericCollectionViewCellController {
    struct Content {
        var posterPath: String?
        var id: Int?
        var title: String?
    }
    
    func build(data: Content) {
        let url = URL(string: "\(Endpoint.fetchMoviePoster.rawValue)" + "\(data.posterPath ?? "")")
        self.movieID = "\(data.id ?? 0)"
        self.moviePoster.kf.setImage(with: url)
        self.movieTitle.text = data.title
        checkFav(data: "\(data.id ?? 0)")
    }
    
    func checkFav(data: String) {
        self.favoriteStar.image = UIImage(named: "star")
        let userDefaults = UserDefaults.standard
        let favoritesList = userDefaults.object(forKey: "favoritesList") as? [String:Dictionary<String, String>] ?? [:]
        
        for item in favoritesList {
            for subItem in item.value {
                if subItem.key == "id", subItem.value == data {
                    self.favoriteStar.image = UIImage(named: "starfill")
                }
            }
        }
    }
    
}
