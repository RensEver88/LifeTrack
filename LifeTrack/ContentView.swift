//
//  ContentView.swift
//  LifeTrack
//
//  Created by Rens Barnhoorn on 01/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tokenViewModel: TokenViewModel
    @StateObject private var actionsViewModel: ActionsViewModel
    @State private var selectedTab = 0
    
    init() {
        let tokenVM = TokenViewModel()
        _tokenViewModel = StateObject(wrappedValue: tokenVM)
        _actionsViewModel = StateObject(wrappedValue: ActionsViewModel(tokenViewModel: tokenVM))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ActionsTabView(viewModel: actionsViewModel)
                .tabItem {
                    Label("Actions", systemImage: "list.bullet")
                }
                .tag(0)
            
            TokenView(viewModel: tokenViewModel)
                .tabItem {
                    Label("Tokens", systemImage: "star.fill")
                }
                .tag(1)
        }
    }
}

private struct ActionsTabView: View {
    @ObservedObject var viewModel: ActionsViewModel
    @State private var showingAddAction = false
    @State private var showingSettings = false
    @State private var actionToDelete: Action?
    @State private var actionToEdit: Action?
    
    var body: some View {
        NavigationView {
            ActionListView(
                actions: viewModel.actions,
                isEditMode: viewModel.isEditMode,
                onIncrement: viewModel.incrementCount,
                onEdit: { actionToEdit = $0 },
                onDelete: { actionToDelete = $0 }
            )
            .navigationTitle("Lifetracker")
            .toolbar {
                leadingToolbarItems
                trailingToolbarItems
            }
            .sheet(isPresented: $showingAddAction) {
                AddActionView { name, tokenMultiple, tokenText, startCount in
                    viewModel.addAction(
                        name: name,
                        tokenMultiple: tokenMultiple,
                        tokenText: tokenText,
                        startCount: startCount
                    )
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(item: $actionToEdit) { action in
                EditActionView(action: action) { updatedName in
                    var updatedAction = action
                    updatedAction.name = updatedName
                    viewModel.updateAction(updatedAction)
                    actionToEdit = nil
                }
            }
            .alert("Delete Action?", isPresented: .constant(actionToDelete != nil)) {
                Button("Cancel", role: .cancel) {
                    actionToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let action = actionToDelete {
                        viewModel.deleteAction(action)
                        actionToDelete = nil
                    }
                }
            } message: {
                Text("Are you sure you want to delete this action?")
            }
        }
    }
    
    private var leadingToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(viewModel.isEditMode ? "Done" : "Edit") {
                viewModel.isEditMode.toggle()
            }
        }
    }
    
    private var trailingToolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: { showingAddAction = true }) {
                Image(systemName: "plus")
            }
            
            Button(action: { showingSettings = true }) {
                Image(systemName: "gear")
            }
        }
    }
}

private struct ActionListView: View {
    let actions: [Action]
    let isEditMode: Bool
    let onIncrement: (Action) -> Void
    let onEdit: (Action) -> Void
    let onDelete: (Action) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(actions) { action in
                    ActionRowView(
                        action: action,
                        isEditMode: isEditMode,
                        onIncrement: { onIncrement(action) },
                        onEdit: { onEdit(action) },
                        onDelete: { onDelete(action) }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }
}

#Preview {
    ContentView()
}
