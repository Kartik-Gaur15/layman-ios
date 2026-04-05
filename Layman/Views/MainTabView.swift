import SwiftUI

struct MainTabView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var articlesVM = ArticlesViewModel()
    
    var body: some View {
        TabView {
            HomeView(vm: articlesVM)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            SavedView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
            
            ProfileView(authVM: authVM)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color(hex: "FF6B35"))
    }
}
