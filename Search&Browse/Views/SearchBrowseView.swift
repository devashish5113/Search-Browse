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
    @State private var selectedGenreFromCard: String? = nil
    
    let genres = ["Fiction", "Science", "History", "Technology", "Business"]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
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
                                        selectedFilter = genre
                                        selectedGenreFromCard = nil
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
                    } else if let selectedGenre = selectedFilter ?? selectedGenreFromCard {
                        // Selected Genre Grid View
                        VStack(alignment: .leading) {
                            Text(selectedGenre)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.booksByGenre[selectedGenre] ?? []) { book in
                                    BookCard(book: book)
                                        .frame(height: 280)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // For You Section
                        VStack(alignment: .leading) {
                            Text("For You")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.forYouBooks) { book in
                                        BookCard(book: book)
                                            .frame(width: 180)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        // Popular Books Section
                        VStack(alignment: .leading) {
                            Text("Popular Books")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.popularBooks) { book in
                                        BookCard(book: book)
                                            .frame(width: 180)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        // Books by Genre Section with Square Cards
                        VStack(alignment: .leading) {
                            Text("Browse by Genre")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(viewModel.booksByGenre.keys.sorted()), id: \.self) { genre in
                                        Button(action: {
                                            selectedGenreFromCard = genre
                                            selectedFilter = nil
                                        }) {
                                            VStack {
                                                if let firstBook = viewModel.booksByGenre[genre]?.first,
                                                   let imageURL = firstBook.imageURL,
                                                   let url = URL(string: imageURL) {
                                                    AsyncImage(url: url) { image in
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                    } placeholder: {
                                                        Color.gray.opacity(0.2)
                                                    }
                                                    .frame(width: 120, height: 120)
                                                    .clipped()
                                                }
                                                
                                                Text(genre)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                            }
                                            .frame(width: 120, height: 160)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .shadow(radius: 4)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 8)
                        
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