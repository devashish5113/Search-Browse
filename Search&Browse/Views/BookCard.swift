//
//  BookCard.swift
//  Search&Browse
//
//  Created by Devashish Upadhyay on 19/03/25.
//

import SwiftUI

struct BookCard: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = book.imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(String(book.publicationYear))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(book.genre)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}