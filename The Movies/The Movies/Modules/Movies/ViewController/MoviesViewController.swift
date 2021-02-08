import UIKit

enum LoadingStatus {
    case start
    case stop
}

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MoviesPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupCollectionView()
        loadingState(state: .start)
        getMovieList()
    }    
}

//MARK: - FUNCTIONS
extension MoviesViewController {
    
    @IBAction func tryAgain(_ sender: Any) {
        loadingState(state: .start)
        getMovieList()
    }
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "GenericCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenericCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupPresenter() {
        presenter = MoviesPresenter()
        presenter?.delegate = self
    }
    
    private func getMovieList() {
        presenter?.getMoviesList()
    }
    
    private func loadingState(state: LoadingStatus) {
        DispatchQueue.main.async {
            if state == .start {
                self.loadingView.isHidden = false
                self.activityIndicator.startAnimating()
            }else {
                self.loadingView.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func showErrorView() {
        self.errorView.isHidden = false
    }
}

//MARK: - COLLECTION VIEW DELEGATE/DATA SOURCE
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfMovieRows() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenericCollectionViewCell", for: indexPath) as? GenericCollectionViewCellController {
            if let data = presenter?.movieForRow(at: indexPath){
                cell.build(data: data)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "MovieDetail", bundle: nil).instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController {
            if let data = presenter?.movieForDetail(at: indexPath) {
                detailVC.data = data
                detailVC.delegate = self
                detailVC.index = indexPath.row
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
        }
    }

}

//MARK: - PRESENTER DELEGATE
extension MoviesViewController: MoviesPresenterDelegate {
    func fetchFailure() {
        loadingState(state: .stop)
        self.showErrorView()
    }
    
    func fetchSuccess() {
        loadingState(state: .stop)
        collectionView.reloadData()
    }
}

//MARK: - COLLECTION VIEW CELL LAYOUT
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 290)
    }
}

//MARK: - MOVIE DETAIL DELEGATE
extension MoviesViewController: MoviesDetailViewControllerDelegate {
    func favoriteMovie(index: Int) {
        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}
