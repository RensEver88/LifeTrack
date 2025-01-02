import SwiftUI

struct TokenView: View {
    @ObservedObject private var viewModel: TokenViewModel
    
    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.tokens.isEmpty {
                    EmptyStateView()
                } else {
                    TokenGridView(tokens: viewModel.tokens) { token in
                        withAnimation {
                            viewModel.removeToken(token)
                        }
                    }
                }
            }
            .navigationTitle("Tokens")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
                .padding(.top, 40)
            
            Text("No Tokens Collected")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Complete actions to earn tokens")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct TokenGridView: View {
    let tokens: [Token]
    let onTokenTap: (Token) -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(tokens) { token in
                    TokenItemView(token: token, onTap: {
                        onTokenTap(token)
                    })
                }
            }
            .padding()
        }
    }
}

private struct TokenItemView: View {
    let token: Token
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(token.text)
                .font(.system(.body, design: .rounded))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            
            Text(token.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(radius: 2)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    TokenView(viewModel: TokenViewModel())
} 