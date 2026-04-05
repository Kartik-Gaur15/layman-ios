import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: article.imageURL ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(hex: "FFD4B2")
            }
            .frame(width: 80, height: 80)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(article.source ?? "News")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "FF6B35"))
                
                Text(article.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(3)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
