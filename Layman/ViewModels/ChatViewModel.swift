import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var suggestions: [String] = []
    @Published var isLoading = false
    
    var article: Article
    
    init(article: Article) {
        self.article = article
        messages.append(ChatMessage(text: "Hi, I'm Layman! What can I answer for you?", isUser: false))
        Task { await loadSuggestions() }
    }
    
    func loadSuggestions() async {
        let s = (try? await GeminiService.shared.generateSuggestions(for: article)) ?? []
        await MainActor.run { suggestions = s }
    }
    
    func send(_ text: String) async {
        await MainActor.run {
            messages.append(ChatMessage(text: text, isUser: true))
            isLoading = true
        }
        let reply = (try? await GeminiService.shared.ask(question: text, articleContext: article.description ?? article.title)) ?? "Sorry, I couldn't answer that."
        await MainActor.run {
            messages.append(ChatMessage(text: reply, isUser: false))
            isLoading = false
        }
    }
}
