import UIKit

protocol FavoritesPresenterDelegate: AnyObject {
    func fetchSuccess()
}

class FavoritesPresenter {
    var delegate: FavoritesPresenterDelegate?
    var userDefaults = UserDefaults.standard
    var favoritesList = [String:String]()
}

//MARK: - OBJECT MAPPERS
extension FavoritesPresenter {
    
    func favoriteMapper() -> [GenericTableViewCellController.Content] {
        let data = userDefaults.object(forKey: "favoritesList") as? [String:Dictionary<String, String>] ?? [:]
        
        var movie = [String:String]()
        var content = [GenericTableViewCellController.Content]()
        
        for item in data {
            for subItem in item.value {
                switch subItem.key {
                case "posterPath":
                    movie["posterPath"] = subItem.value
                case "overview":
                    movie["overview"] = subItem.value
                case "releaseDate":
                    movie["releaseDate"] = subItem.value
                case "id":
                    movie["id"] = subItem.value
                case "title":
                    movie["title"] = subItem.value
                default:
                    break
                }
            }
                
            let favorites = GenericTableViewCellController.Content(
                posterPath: movie["posterPath"] ?? "",
                overview: movie["overview"] ?? "",
                releaseDate: movie["releaseDate"] ?? "",
                id: movie["id"] ?? "",
                title: movie["title"] ?? "")
            
            content.append(favorites)
        }
        return content.sorted(by: { $0.id ?? "" > $1.id ?? ""})
    }
}

//MARK: - CELLS BUILDERS
extension FavoritesPresenter {
    
    func favoritesRows() -> Int{
        return self.favoriteMapper().count
    }
    
    func favoriteForRow(at indexPath: IndexPath) -> GenericTableViewCellController.Content{
        let array = self.favoriteMapper()
        return array[indexPath.row]
    }
}

//MARK: - FAVORITES MANAGEMENT
extension FavoritesPresenter {
    func buildFav(data: GenericTableViewCellController.Content?) -> [String:Dictionary<String, String>]{
        var content = [String:String]()
        
        content["id"] = "\(data?.id ?? "")"
        content["overview"] = data?.overview
        content["releaseDate"] = data?.releaseDate
        content["title"] = data?.title
        content["posterPath"] = data?.posterPath
        
        var fav = [String:Dictionary<String, String>]()
        fav["\(data?.id ?? "")"] = content
        return fav
    }
    
    func checkFav(data: GenericTableViewCellController.Content?) -> Bool {
        let userDefaults = UserDefaults.standard
        let favoritesList = userDefaults.object(forKey: "favoritesList") as? [String:Dictionary<String, String>] ?? [:]
        var result = false
        
        for item in favoritesList {
            for subItem in item.value {
                if subItem.value == data?.id {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
}

