//
//  ClosetHeaderView.swift
//  fitpick
//
//  Created by Bryan Gavino on 1/19/26.
//

import SwiftUI

struct ClosetHeaderView: View {
    let portraitImage: Image?

    var body: some View {
        ZStack {
            if let portraitImage {
                portraitImage
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300) // Taller for a better portrait view
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
            } else {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 200)
            }

            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(portraitImage == nil ? "Upload Portrait" : "Virtual Mirror")
                            .font(.headline)
                            .foregroundColor(portraitImage == nil ? .primary : .white)
                        
                        Text(portraitImage == nil ? "Tap to add a photo of yourself" : "Select clothes below to try them on")
                            .font(.caption)
                            .foregroundColor(portraitImage == nil ? .secondary : .white.opacity(0.8))
                    }
                    Spacer()
                    Image(systemName: portraitImage == nil ? "camera.fill" : "sparkles")
                        .font(.title2)
                        .foregroundColor(portraitImage == nil ? .gray : .yellow)
                }
                .padding()
            }
        }
    }
}
