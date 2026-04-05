import Foundation

class SavedViewModel: ObservableObject {
    @Published var savedArticles: [Article] = []
    @Published var searchText = ""
    
    var filtered: [Article] {
        if searchText.isEmpty { return savedArticles }
        return savedArticles.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    func fetchSaved() async {
        do {
            let articles = try await SupabaseService.shared.fetchSavedArticles()
            await MainActor.run { self.savedArticles = articles }
        } catch {
            print("Error fetching saved: \(error)")
        }
    }
    
    func unsave(_ article: Article) async {
        do {
            try await SupabaseService.shared.unsaveArticle(article)
            await MainActor.run {
                savedArticles.removeAll { $0.id == article.id }
            }
        } catch {
            print("Error unsaving: \(error)")
        }
    }
}
