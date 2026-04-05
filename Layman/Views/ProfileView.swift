import SwiftUI

struct ProfileView: View {
    @ObservedObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "FFF8F0").ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Circle()
                    .fill(Color(hex: "FF6B35"))
                    .frame(width: 80, height: 80)
                    .overlay(Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 36)))
                
                Text(authVM.currentUserEmail)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                Button {
                    Task { await authVM.signOut() }
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color(hex: "FF6B35"))
                        .cornerRadius(14)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}
