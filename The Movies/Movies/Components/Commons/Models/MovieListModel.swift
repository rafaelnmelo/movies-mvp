struct MovieListModel: Codable {
    let page: Int
    let results: [Movie]
    let totalResults: Int
    let totalPages: Int
    
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    let posterPath: String
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let title: String
    let backdropPath: String
    
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case overview = "overview"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id = "id"
        case title = "title"
        case backdropPath = "backdrop_path"
    }
}
