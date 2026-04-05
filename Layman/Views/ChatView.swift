import SwiftUI

struct ChatView: View {
    let article: Article
    @StateObject private var vm: ChatViewModel
    @State private var inputText = ""
    @Environment(\.dismiss) var dismiss
    
    init(article: Article) {
        self.article = article
        _vm = StateObject(wrappedValue: ChatViewModel(article: article))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "FFF8F0").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Ask Layman")
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                }
                .padding()
                
                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(vm.messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }
                            
                            if vm.isLoading {
                                HStack {
                                    ProgressView()
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            
                            // Suggestions
                            if !vm.suggestions.isEmpty && vm.messages.count == 1 {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(vm.suggestions, id: \.self) { s in
                                            Button {
                                                Task { await vm.send(s) }
                                            } label: {
                                                Text(s)
                                                    .font(.system(size: 13))
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 8)
                                                    .background(Color(hex: "FF6B35"))
                                                    .cornerRadius(20)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                        .onChange(of: vm.messages.count) {
                            proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                // Input bar
                HStack(spacing: 12) {
                    TextField("Type your question...", text: $inputText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                    
                    Button {
                        let text = inputText
                        inputText = ""
                        Task { await vm.send(text) }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(Color(hex: "FF6B35"))
                    }
                    .disabled(inputText.isEmpty)
                }
                .padding()
                .background(Color(hex: "FFF8F0"))
            }
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if !message.isUser {
                Circle()
                    .fill(Color(hex: "FF6B35"))
                    .frame(width: 32, height: 32)
                    .overlay(Text("L")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold)))
            }
            
            Text(message.text)
                .font(.system(size: 15))
                .padding(12)
                .background(message.isUser ? Color(hex: "FF6B35") : Color.white)
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 4)
            
            if message.isUser { Spacer() }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}
