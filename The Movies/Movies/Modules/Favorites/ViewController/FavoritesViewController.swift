import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListView: UIView!
    
    private var presenter: FavoritesPresenter?
    var list = UserDefaultsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    //MARK: - FUNCTIONS
    private func setupTableView() {
        tableView.register(UINib(nibName: "GenericTableViewCell", bundle: nil), forCellReuseIdentifier: "GenericTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupPresenter() {
        presenter = FavoritesPresenter()
    }
}

//MARK: - TABLEVIEW DELEGATE
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - TABLEVIEW DATASOURCE
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.emptyListView.isHidden = true
        if self.presenter?.favoritesRows() == 0 {
            self.emptyListView.isHidden = false
        }
        return self.presenter?.favoritesRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as? GenericTableViewCellController {
            if let data = presenter?.favoriteForRow(at: indexPath) {
                cell.build(data: data)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let data = presenter?.favoriteForRow(at: indexPath) {
                guard let fav = presenter?.buildFav(data: data) else { return }
                let result = presenter?.checkFav(data: data)
                if result == true {
                    list.removeFromFav(fav)
                    tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - PRESENTER DELEGATE
extension FavoritesViewController: FavoritesPresenterDelegate {
    func fetchSuccess() {
        tableView.reloadData() /// Realimentar a tableview com todos seus métodos
    }
}
