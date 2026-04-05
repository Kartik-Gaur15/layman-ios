import SwiftUI

struct WelcomeView: View {
    @Binding var showAuth: Bool
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "FFD4B2"), Color(hex: "FF6B35")],
                          startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Layman")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Business, tech & startups ")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.9))
                    + Text("made simple")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Swipe to get started
                ZStack {
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 280, height: 60)
                    
                    Text("Swipe to get started →")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack {
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 52, height: 52)
                            .overlay(Image(systemName: "arrow.right")
                                .foregroundColor(Color(hex: "FF6B35")))
                            .offset(x: offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { val in
                                        if val.translation.width > 0 {
                                            offset = min(val.translation.width, 220)
                                        }
                                    }
                                    .onEnded { val in
                                        if offset > 150 {
                                            showAuth = true
                                        } else {
                                            withAnimation { offset = 0 }
                                        }
                                    }
                            )
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .frame(width: 280)
                }
                .padding(.bottom, 60)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
