import Foundation

struct Article: Identifiable, Codable {
    let id: String
    let title: String
    let description: String?
    let imageURL: String?
    let url: String
    let source: String?
    var isSaved: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "article_id"
        case title
        case description
        case imageURL = "image_url"
        case url = "link"
        case source = "source_id"
    }
}
