//
//  SearchSuggestionsView.swift
//  Search&Browse
//
//  Created by Devashish Upadhyay on 19/03/25.
//

import SwiftUI

struct SearchSuggestionsView: View {
    let books: [Book]
    @Binding var showingSuggestions: Bool
    @Binding var selectedBook: Book?
    @Binding var selectedAuthor: String?
    @Binding var selectedFilter: String?
    @Binding var searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(books.prefix(3))) { book in
                VStack(alignment: .leading) {
                    Button(action: {
                        selectedBook = book
                        showingSuggestions = false
                        searchText = ""
                    }) {
                        Text(book.title)
                            .foregroundColor(.primary)
                    }
                    Button(action: {
                        selectedAuthor = book.author
                        showingSuggestions = false
                        searchText = ""
                    }) {
                        Text(book.author)
                            .foregroundColor(.secondary)
                    }
                    Button(action: {
                        selectedFilter = book.genre
                        showingSuggestions = false
                        searchText = ""
                    }) {
                        Text(book.genre)
                            .foregroundColor(.blue)
                    }
                    Divider()
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}