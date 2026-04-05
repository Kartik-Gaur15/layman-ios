import Foundation

class GeminiService {
    static let shared = GeminiService()
    
    func ask(question: String, articleContext: String) async throws -> String {
        let prompt = """
        You are Layman, a friendly news assistant. Answer in 1-2 simple sentences in casual everyday language.
        Article context: \(articleContext)
        Question: \(question)
        """
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(Config.geminiAPIKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "contents": [["parts": [["text": prompt]]]]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let candidates = json?["candidates"] as? [[String: Any]]
        let content = candidates?.first?["content"] as? [String: Any]
        let parts = content?["parts"] as? [[String: Any]]
        return parts?.first?["text"] as? String ?? "Sorry, I couldn't answer that."
    }
    
    func generateSuggestions(for article: Article) async throws -> [String] {
        let prompt = """
        Generate exactly 3 short curious questions a reader might ask about this article.
        Each question must be max 8 words.
        Return ONLY a JSON array like: ["Question 1?", "Question 2?", "Question 3?"]
        Article: \(article.title)
        """
        let response = try await ask(question: prompt, articleContext: article.title)
        let cleaned = response.trimmingCharacters(in: .whitespacesAndNewlines)
        if let data = cleaned.data(using: .utf8),
           let arr = try? JSONDecoder().decode([String].self, from: data) {
            return arr
        }
        return ["What happened here?", "Who is involved?", "Why does this matter?"]
    }
    
    func simplifyArticle(_ article: Article) async throws -> [String] {
        let prompt = """
        Summarize this article in exactly 3 parts. Each part must be exactly 2 sentences in simple casual language (28-35 words each).
        Return ONLY a JSON array with exactly 3 strings: ["Part 1 two sentences.", "Part 2 two sentences.", "Part 3 two sentences."]
        Article title: \(article.title)
        Article content: \(article.description ?? article.title)
        """
        let response = try await ask(question: prompt, articleContext: article.title)
        let cleaned = response.trimmingCharacters(in: .whitespacesAndNewlines)
        if let data = cleaned.data(using: .utf8),
           let arr = try? JSONDecoder().decode([String].self, from: data) {
            return arr
        }
        return [
            article.description ?? article.title,
            "This story is still developing. More details are expected soon.",
            "Experts are watching this closely. It could have a big impact."
        ]
    }
}
