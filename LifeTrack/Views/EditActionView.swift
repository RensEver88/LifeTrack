import SwiftUI

struct EditActionView: View {
    let action: Action
    @Environment(\.dismiss) var dismiss
    @State private var actionName: String
    let onEdit: (String) -> Void
    
    init(action: Action, onEdit: @escaping (String) -> Void) {
        self.action = action
        self._actionName = State(initialValue: action.name)
        self.onEdit = onEdit
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Action name", text: $actionName)
            }
            .navigationTitle("Edit Action")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    if !actionName.isEmpty {
                        onEdit(actionName)
                        dismiss()
                    }
                }
                .disabled(actionName.isEmpty)
            )
        }
    }
} 