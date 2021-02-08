import Foundation

enum UserDefaultsKeys: String {
    case favoritesList
}

class UserDefaultsManager {
    
    public static var shared = UserDefaultsManager()
    var userDefaults = UserDefaults.standard
    var favoritesList = [String:Dictionary<String, String>]()

    func addToFav(_ movie: [String:Dictionary<String, String>]) {
        favoritesList = userDefaults.object(forKey: "favoritesList") as? [String:Dictionary<String, String>] ?? [:]
        for item in movie {
            favoritesList["\(item.key)"] = item.value
        }
        
        userDefaults.set(favoritesList, forKey: UserDefaultsKeys.favoritesList.rawValue)
    }
    
    func removeFromFav(_ movie: [String:Dictionary<String, String>]) {
        favoritesList = userDefaults.object(forKey: "favoritesList") as? [String:Dictionary<String, String>] ?? [:]
        guard let id = movie.first?.key else {return}
        favoritesList.removeValue(forKey: id)
        userDefaults.set(favoritesList, forKey: UserDefaultsKeys.favoritesList.rawValue)
    }
}
