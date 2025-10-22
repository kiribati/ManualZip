//
//  AddImageCell.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/22/25.
//

import SwiftUI

struct AddImageCell: View {
    let uiImage: UIImage
    let index: Int
    let onDelete: (Int) -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1))
            
            Button {
                onDelete(index)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.black.opacity(0.4))
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0))
                            .frame(width: 25, height: 25))
            }
        }
    }
}

