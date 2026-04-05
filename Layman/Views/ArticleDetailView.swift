import SwiftUI
import SafariServices

struct ArticleDetailView: View {
    let article: Article
    @ObservedObject var articlesVM: ArticlesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var cardIndex = 0
    @State private var simplifiedParts: [String] = []
    @State private var isLoading = true
    @State private var showChat = false
    @State private var showSafari = false
    @State private var isSaved = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "FFF8F0").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Top bar
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Button { showSafari = true } label: {
                                Image(systemName: "link")
                                    .foregroundColor(.black)
                            }
                            Button {
                                Task { await articlesVM.toggleSave(article); isSaved.toggle() }
                            } label: {
                                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(isSaved ? Color(hex: "FF6B35") : .black)
                            }
                            Button {
                                let av = UIActivityViewController(activityItems: [article.url], applicationActivities: nil)
                                UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .first?.windows.first?.rootViewController?
                                    .present(av, animated: true)
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    
                    // Headline
                    Text(article.title)
                        .font(.system(size: 22, weight: .bold))
                        .lineLimit(2)
                        .padding(.horizontal)
                    
                    // Image
                    AsyncImage(url: URL(string: article.imageURL ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color(hex: "FFD4B2")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
                    .padding(.vertical, 16)
                    
                    // Content Cards
                    if isLoading {
                        ProgressView("Simplifying article...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else {
                        VStack(spacing: 12) {
                            TabView(selection: $cardIndex) {
                                ForEach(Array(simplifiedParts.enumerated()), id: \.offset) { i, part in
                                    ContentCardView(text: part)
                                        .tag(i)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height: 180)
                            
                            HStack(spacing: 6) {
                                ForEach(0..<simplifiedParts.count, id: \.self) { i in
                                    Circle()
                                        .fill(i == cardIndex ? Color(hex: "FF6B35") : Color.gray.opacity(0.4))
                                        .frame(width: i == cardIndex ? 10 : 6, height: i == cardIndex ? 10 : 6)
                                        .animation(.spring(), value: cardIndex)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer().frame(height: 100)
                }
            }
            
            // Ask Layman Button
            Button { showChat = true } label: {
                HStack {
                    Image(systemName: "bubble.left.fill")
                    Text("Ask Layman")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color(hex: "FF6B35"))
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                let parts = try? await GeminiService.shared.simplifyArticle(article)
                let saved = try? await SupabaseService.shared.isArticleSaved(article)
                await MainActor.run {
                    simplifiedParts = parts ?? [article.description ?? "", "", ""]
                    isSaved = saved ?? false
                    isLoading = false
                }
            }
        }
        .sheet(isPresented: $showChat) {
            ChatView(article: article)
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: article.url) ?? URL(string: "https://google.com")!)
        }
    }
}

struct ContentCardView: View {
    let text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.07), radius: 8)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.85))
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .padding(20)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
