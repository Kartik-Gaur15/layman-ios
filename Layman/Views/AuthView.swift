import SwiftUI

struct AuthView: View {
    @ObservedObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        ZStack {
            Color(hex: "FFF8F0").ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Text("Layman")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color(hex: "FF6B35"))
                
                Text(isSignUp ? "Create an account" : "Welcome back")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.05), radius: 4)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.05), radius: 4)
                }
                .padding(.horizontal)
                
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button {
                    Task {
                        if isSignUp {
                            await authVM.signUp(email: email, password: password)
                        } else {
                            await authVM.signIn(email: email, password: password)
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "FF6B35"))
                            .frame(height: 54)
                        if authVM.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text(isSignUp ? "Sign Up" : "Log In")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .semibold))
                        }
                    }
                }
                .padding(.horizontal)
                .disabled(authVM.isLoading)
                
                Button {
                    isSignUp.toggle()
                    authVM.errorMessage = ""
                } label: {
                    Text(isSignUp ? "Already have an account? Log in" : "Don't have an account? Sign up")
                        .foregroundColor(Color(hex: "FF6B35"))
                        .font(.system(size: 15))
                }
                
                Spacer()
            }
        }
    }
}
