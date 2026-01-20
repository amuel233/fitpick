//
//  ContentView.swift
//  fitpick
//
//  Created by Amuel Ryco Nidoy on 1/9/26.
//

import SwiftUI
import PhotosUI

struct ClosetView: View {
    // Data Storage
    @State private var clothingItems: [ClothingItem] = []
    @State private var userPortrait: Image? = nil
    
    // Photo Picker States
    @State private var selectedClothingItem: PhotosPickerItem? = nil
    @State private var selectedPortraitItem: PhotosPickerItem? = nil
    
    // Internal Logic States
    @State private var tempImage: Image? = nil
    @State private var showingCategoryPicker = false

    var body: some View {
        NavigationStack {
            List {
                // SECTION 1: User Portrait (The Placeholder)
                Section {
                    PhotosPicker(selection: $selectedPortraitItem, matching: .images) {
                        ClosetHeaderView(portraitImage: userPortrait)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

                // SECTION 2: Upload Button
                Section {
                    PhotosPicker(selection: $selectedClothingItem, matching: .images) {
                        Label("Add to Closet", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .listRowSeparator(.hidden)

                // SECTION 3: Categorized Inventory
                ForEach(ClothingCategory.allCases) { category in
                    VStack(alignment: .leading) {
                        Label(category.rawValue, systemImage: category.icon)
                            .font(.headline)
                            .padding(.top, 8)
                        
                        let filtered = clothingItems.filter { $0.category == category }
                        
                        if filtered.isEmpty {
                            Text("No items yet")
                                .font(.caption).foregroundColor(.secondary)
                                .frame(height: 100)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(filtered) { item in
                                        item.image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 130)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Closet")
            // NEW iOS 17 Syntax
            .onChange(of: selectedClothingItem) { _, _ in handleClothingSelection() }
            .onChange(of: selectedPortraitItem) { _, _ in handlePortraitSelection() }
            // Category Selection
            .confirmationDialog("Category", isPresented: $showingCategoryPicker) {
                ForEach(ClothingCategory.allCases) { category in
                    Button(category.rawValue) { saveClothingItem(as: category) }
                }
                Button("Cancel", role: .cancel) { tempImage = nil }
            }
        }
    }
}

// MARK: - Logic Extension
private extension ClosetView {
    func handleClothingSelection() {
        Task {
            if let data = try? await selectedClothingItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.tempImage = Image(uiImage: uiImage)
                    self.showingCategoryPicker = true
                }
            }
        }
    }

    func handlePortraitSelection() {
        Task {
            if let data = try? await selectedPortraitItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.userPortrait = Image(uiImage: uiImage)
                }
            }
        }
    }

    func saveClothingItem(as category: ClothingCategory) {
        if let image = tempImage {
            let newItem = ClothingItem(image: image, category: category)
            clothingItems.append(newItem)
            tempImage = nil
            selectedClothingItem = nil
        }
    }
}
