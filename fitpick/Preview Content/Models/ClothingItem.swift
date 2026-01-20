//
//  ClothingItem.swift
//  fitpick
//
//  Created by Bryan Gavino on 1/19/26.
//

import SwiftUI

enum ClothingCategory: String, CaseIterable, Identifiable {
    case top = "Top"
    case bottom = "Bottom"
    case shoes = "Shoes"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .top: return "tshirt"
        case .bottom: return "figure.walk"
        case .shoes: return "shoe"
        }
    }
}

struct ClothingItem: Identifiable {
    let id = UUID()
    let image: Image
    let category: ClothingCategory
}
