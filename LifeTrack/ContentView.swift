//
//  ContentView.swift
//  LifeTrack
//
//  Created by Rens Barnhoorn on 01/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ActionsViewModel()
    @State private var showingAddAction = false
    @State private var showingSettings = false
    @State private var newActionName = ""
    @State private var showingDeleteAlert = false
    @State private var actionToDelete: Action?
    @State private var actionToEdit: Action?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.actions) { action in
                        ActionRowView(action: action,
                                    isEditMode: viewModel.isEditMode,
                                    onIncrement: { viewModel.incrementCount(for: action) },
                                    onEdit: { actionToEdit = action },
                                    onDelete: {
                            actionToDelete = action
                            showingDeleteAlert = true
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .navigationTitle("Lifetracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(viewModel.isEditMode ? "Done" : "Edit") {
                        viewModel.isEditMode.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddAction = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingAddAction) {
                AddActionView(isPresented: $showingAddAction) { name in
                    viewModel.addAction(name: name)
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
            .alert("Delete Action?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let action = actionToDelete {
                        viewModel.deleteAction(action)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this action?")
            }
        }
    }
}

#Preview {
    ContentView()
}
