import UIKit
import Kingfisher

class GenericTableViewCellController: UITableViewCell {
    
    @IBOutlet weak private var moviePoster: UIImageView!
    @IBOutlet weak private var movieTitle: UILabel!
    @IBOutlet weak private var movieReleaseDate: UILabel!
    @IBOutlet weak private var movieOverview: UILabel!
    private var movieID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension GenericTableViewCellController {
    struct Content {
        var posterPath: String?
        var overview: String?
        var releaseDate: String?
        var id: String?
        var title: String?
    }
    
    func build(data: Content) {
        let url = URL(string: "\(Endpoint.fetchMoviePoster.rawValue)" + "\(data.posterPath ?? "")")
        
        self.moviePoster.kf.setImage(with: url)
        self.movieTitle.text = data.title
        self.movieOverview.text = data.overview
        self.movieReleaseDate.text = data.releaseDate
        self.movieID = "\(data.id ?? "")"
    }
    
    
}
