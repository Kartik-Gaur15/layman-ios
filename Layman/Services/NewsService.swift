import Foundation

class NewsService: ObservableObject {
    static let shared = NewsService()
    
    func fetchArticles() async throws -> [Article] {
        let urlString = "https://newsdata.io/api/1/news?apikey=\(Config.newsAPIKey)&category=business,technology&language=en&size=10"
        guard let url = URL(string: urlString) else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(NewsResponse.self, from: data)
        return response.results.compactMap { item in
            guard let imageURL = item.image_url else { return nil }
            return Article(id: item.article_id, title: item.title,
                         description: item.description, imageURL: imageURL,
                         url: item.link, source: item.source_id)
        }
    }
}

struct NewsResponse: Codable {
    let results: [NewsItem]
}

struct NewsItem: Codable {
    let article_id: String
    let title: String
    let description: String?
    let image_url: String?
    let link: String
    let source_id: String?
}
