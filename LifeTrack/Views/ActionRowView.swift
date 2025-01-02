import SwiftUI

struct ActionRowView: View {
    let action: Action
    let isEditMode: Bool
    let onIncrement: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private func containsEight(_ number: Int) -> Bool {
        return String(number).contains("8")
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                if isEditMode {
                    Button(action: onDelete) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }
                }
                
                Text(action.name)
                    .font(.title3)
                    .lineLimit(1)
                    .onTapGesture(perform: isEditMode ? onEdit : {})
                
                Spacer()
                
                Button(action: onIncrement) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(action.canTapToday() ? .blue : .gray)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                }
                .disabled(!action.canTapToday())
                
                Text("\(action.count)")
                    .font(.title2)
                    .bold()
                    .frame(width: 44, height: 44)
                    .monospacedDigit()
                    .foregroundColor(containsEight(action.count) ? Color(hex: "F88F2B") : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal, 16)
        }
    }
}

// Helper extension om hex kleuren te gebruiken
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 