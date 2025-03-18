//
//  AuthorBooksView.swift
//  Search&Browse
//
//  Created by Devashish Upadhyay on 19/03/25.
//

import SwiftUI

struct Author: Identifiable {
    let id = UUID()
    let name: String
}

struct AuthorBooksView: View {
    let author: String
    let books: [Book]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Books by \(author)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(books) { book in
                        NavigationLink(destination: BookDetailView(book: book)) {
                            BookCard(book: book)
                                .frame(height: 280)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}