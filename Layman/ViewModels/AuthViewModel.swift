import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var currentUserEmail = ""
    
    init() {
        // Check if user was previously logged in
        if let email = UserDefaults.standard.string(forKey: "userEmail") {
            self.isLoggedIn = true
            self.currentUserEmail = email
        }
    }
    
    func signUp(email: String, password: String) async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        // Basic validation
        guard email.contains("@") else {
            await MainActor.run { errorMessage = "Enter a valid email"; isLoading = false }
            return
        }
        guard password.count >= 6 else {
            await MainActor.run { errorMessage = "Password must be 6+ characters"; isLoading = false }
            return
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        UserDefaults.standard.set(email, forKey: "userEmail")
        await MainActor.run {
            isLoggedIn = true
            currentUserEmail = email
            isLoading = false
        }
    }
    
    func signIn(email: String, password: String) async {
        await MainActor.run { isLoading = true; errorMessage = "" }
        guard email.contains("@") else {
            await MainActor.run { errorMessage = "Enter a valid email"; isLoading = false }
            return
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        UserDefaults.standard.set(email, forKey: "userEmail")
        await MainActor.run {
            isLoggedIn = true
            currentUserEmail = email
            isLoading = false
        }
    }
    
    func signOut() async {
        UserDefaults.standard.removeObject(forKey: "userEmail")
        await MainActor.run {
            isLoggedIn = false
            currentUserEmail = ""
        }
    }
}
