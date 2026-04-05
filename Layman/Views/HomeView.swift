import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: ArticlesViewModel
    @State private var selectedArticle: Article?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "FFF8F0").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        HStack {
                            Text("Layman")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: "FF6B35"))
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search articles...", text: $vm.searchText)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        if vm.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                        } else {
                            // Featured Carousel
                            if !vm.featured.isEmpty {
                                Text("Featured")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.horizontal)
                                
                                FeaturedCarousel(articles: vm.featured, onTap: { selectedArticle = $0 })
                            }
                            
                            // Today's Picks
                            HStack {
                                Text("Today's Picks")
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                Text("View All")
                                    .foregroundColor(Color(hex: "FF6B35"))
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal)
                            
                            ForEach(vm.todaysPicks) { article in
                                ArticleRow(article: article)
                                    .onTapGesture { selectedArticle = article }
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                Task { await vm.fetchArticles() }
            }
            .sheet(item: $selectedArticle) { article in
                ArticleDetailView(article: article, articlesVM: vm)
            }
        }
    }
}
