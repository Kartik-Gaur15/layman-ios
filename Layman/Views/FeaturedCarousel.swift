import SwiftUI

struct FeaturedCarousel: View {
    let articles: [Article]
    let onTap: (Article) -> Void
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $currentIndex) {
                ForEach(Array(articles.enumerated()), id: \.offset) { index, article in
                    FeaturedCard(article: article)
                        .onTapGesture { onTap(article) }
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 220)
            
            // Dots
            HStack(spacing: 6) {
                ForEach(0..<articles.count, id: \.self) { i in
                    Circle()
                        .fill(i == currentIndex ? Color(hex: "FF6B35") : Color.gray.opacity(0.4))
                        .frame(width: i == currentIndex ? 10 : 6, height: i == currentIndex ? 10 : 6)
                        .animation(.spring(), value: currentIndex)
                }
            }
        }
    }
}

struct FeaturedCard: View {
    let article: Article
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: article.imageURL ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(hex: "FFD4B2")
            }
            .frame(height: 220)
            .clipped()
            .cornerRadius(20)
            
            LinearGradient(colors: [.clear, .black.opacity(0.7)],
                          startPoint: .center, endPoint: .bottom)
                .cornerRadius(20)
            
            Text(article.title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(16)
        }
        .padding(.horizontal)
        .cornerRadius(20)
    }
}
