import SwiftUI

@main
struct LaymanApp: App {
    @StateObject private var authVM = AuthViewModel()
    @State private var showAuth = false
    
    var body: some Scene {
        WindowGroup {
            if authVM.isLoggedIn {
                MainTabView(authVM: authVM)
            } else if showAuth {
                AuthView(authVM: authVM)
            } else {
                WelcomeView(showAuth: $showAuth)
            }
        }
    }
}
