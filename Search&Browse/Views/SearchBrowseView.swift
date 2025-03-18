//
//  SearchBrowseView.swift
//  Search&Browse
//
//  Created by Devashish Upadhyay on 19/03/25.
//

import SwiftUI

struct SearchBrowseView: View {
    @StateObject private var viewModel = BookSearchViewModel()
    @State private var selectedFilter: String? = nil
    
    let genres = ["Fiction", "Science", "History", "Technology", "Business"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search by title, author, or genre", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: viewModel.searchText) { _ in
                                viewModel.searchBooks()
                            }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Genre Categories
                    VStack(alignment: .leading) {
                        Text("Categories")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(genres, id: \.self) { genre in
                                    Button(action: {
                                        viewModel.fetchBooksByGenre(genre)
                                        selectedFilter = genre
                                    }) {
                                        Text(genre)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedFilter == genre ? Color.blue : Color.gray.opacity(0.1))
                                            .foregroundColor(selectedFilter == genre ? .white : .primary)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Books by Genre Sections
                        ForEach(Array(viewModel.booksByGenre.keys.sorted()), id: \.self) { genre in
                            if !viewModel.booksByGenre[genre]!.isEmpty {
                                VStack(alignment: .leading) {
                                    Text(genre)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(viewModel.booksByGenre[genre]!) { book in
                                                BookCard(book: book)
                                                    .frame(width: 180)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        
                        // Search Results Section
                        if !viewModel.searchText.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Search Results")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                if viewModel.books.isEmpty {
                                    Text("No books found")
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(viewModel.books) { book in
                                                BookCard(book: book)
                                                    .frame(width: 180)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Book Catalog")
        }
    }
}