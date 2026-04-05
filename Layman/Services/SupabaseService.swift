import Foundation

class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    private var savedArticles: [Article] = []
    
    func signUp(email: String, password: String) async throws {
        // Mock signup
    }
    
    func signIn(email: String, password: String) async throws {
        // Mock signin
    }
    
    func signOut() async throws {
        // Mock signout
    }
    
    func getCurrentUser() async -> String? {
        return UserDefaults.standard.string(forKey: "userEmail")
    }
    
    func saveArticle(_ article: Article) async throws {
        savedArticles.append(article)
    }
    
    func unsaveArticle(_ article: Article) async throws {
        savedArticles.removeAll { $0.id == article.id }
    }
    
    func fetchSavedArticles() async throws -> [Article] {
        return savedArticles
    }
    
    func isArticleSaved(_ article: Article) async throws -> Bool {
        return savedArticles.contains { $0.id == article.id }
    }
}
