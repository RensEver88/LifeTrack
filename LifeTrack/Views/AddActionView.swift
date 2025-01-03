import SwiftUI

struct AddActionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var actionName = ""
    @State private var tokenMultiple = 5
    @State private var tokenText = "Achievement token"
    @State private var showingStartCount = false
    @State private var startCount = 0
    
    let onAdd: (String, Int, String, Int) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Action Details")) {
                    TextField("Action name", text: $actionName)
                        .autocapitalization(.sentences)
                    
                    if showingStartCount {
                        Stepper("Starting count: \(startCount)", value: $startCount, in: 0...9999)
                    }
                }
                
                Section(
                    header: Text("Token Settings"),
                    footer: Text("A token with the text '\(tokenText)' will be created every \(tokenMultiple) times you complete this action.")
                ) {
                    Stepper("Create token every \(tokenMultiple) counts", value: $tokenMultiple, in: 1...100)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Token text")
                            .foregroundStyle(.secondary)
                        TextField("Token text", text: $tokenText)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.sentences)
                    }
                }
            }
            .navigationTitle("New Action")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !actionName.isEmpty {
                            onAdd(actionName, tokenMultiple, tokenText, startCount)
                            dismiss()
                        }
                    }
                    .disabled(actionName.isEmpty)
                }
                ToolbarItem(placement: .principal) {
                    Text("New Action")
                        .onLongPressGesture {
                            withAnimation {
                                showingStartCount.toggle()
                            }
                        }
                }
            }
        }
    }
} 