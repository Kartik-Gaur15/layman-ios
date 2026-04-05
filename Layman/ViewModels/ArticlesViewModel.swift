import Foundation

class ArticlesViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var searchText = ""
    
    var featured: [Article] { Array(articles.prefix(5)) }
    
    var todaysPicks: [Article] {
        let filtered = articles.dropFirst(5)
        if searchText.isEmpty { return Array(filtered) }
        return filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    func fetchArticles() async {
        await MainActor.run { isLoading = true }
        do {
            let fetched = try await NewsService.shared.fetchArticles()
            await MainActor.run { self.articles = fetched }
        } catch {
            print("Error fetching articles: \(error)")
        }
        await MainActor.run { isLoading = false }
    }
    
    func toggleSave(_ article: Article) async {
        do {
            if article.isSaved {
                try await SupabaseService.shared.unsaveArticle(article)
            } else {
                try await SupabaseService.shared.saveArticle(article)
            }
            await MainActor.run {
                if let index = articles.firstIndex(where: { $0.id == article.id }) {
                    articles[index].isSaved.toggle()
                }
            }
        } catch {
            print("Error toggling save: \(error)")
        }
    }
}
