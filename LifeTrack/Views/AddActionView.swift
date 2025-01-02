import SwiftUI

struct AddActionView: View {
    @Binding var isPresented: Bool
    @State private var actionName = ""
    let onAdd: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Action name", text: $actionName)
            }
            .navigationTitle("New Action")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Add") {
                    if !actionName.isEmpty {
                        onAdd(actionName)
                        isPresented = false
                    }
                }
                .disabled(actionName.isEmpty)
            )
        }
    }
} 