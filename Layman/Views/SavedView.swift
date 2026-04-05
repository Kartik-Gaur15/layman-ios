import SwiftUI

struct SavedView: View {
    @StateObject private var vm = SavedViewModel()
    @State private var selectedArticle: Article?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "FFF8F0").ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Saved")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        TextField("Search saved...", text: $vm.searchText)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    if vm.filtered.isEmpty {
                        Spacer()
                        Text("No saved articles yet")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(vm.filtered) { article in
                                    ArticleRow(article: article)
                                        .onTapGesture { selectedArticle = article }
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear { Task { await vm.fetchSaved() } }
            .sheet(item: $selectedArticle) { article in
                ArticleDetailView(article: article, articlesVM: ArticlesViewModel())
            }
        }
    }
}
