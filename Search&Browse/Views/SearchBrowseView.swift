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
    @State private var showingSuggestions = false
    @State private var selectedBook: Book? = nil
    @State private var selectedAuthor: String? = nil
    @State private var initialBooksByGenre: [String: [Book]] = [:]
    
    let userName = "Bunny"
    let genres = ["Fiction", "Science", "History", "Technology", "Business"]
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hi \(userName)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Search Bar
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search by title, author, or genre", text: $viewModel.searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: viewModel.searchText) { _ in
                                    viewModel.searchBooks()
                                    showingSuggestions = !viewModel.searchText.isEmpty
                                }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                        if showingSuggestions && !viewModel.books.isEmpty {
                            SearchSuggestionsView(
                                books: viewModel.books,
                                showingSuggestions: $showingSuggestions,
                                selectedBook: $selectedBook,
                                selectedAuthor: $selectedAuthor,
                                selectedFilter: $selectedFilter,
                                searchText: $viewModel.searchText
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    GenreCategoriesView(
                        genres: genres,
                        selectedFilter: $selectedFilter,
                        selectedGenreFromCard: $selectedGenreFromCard
                    )
                    
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
                                                .frame(width: 160)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.horizontal)
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
                                ForEach(initialBooksByGenre[selectedGenre] ?? []) { book in
                                    BookCard(book: book)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 280)
                                        .padding(.horizontal, 8)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        BookSectionsView(
                            forYouBooks: viewModel.forYouBooks,
                            popularBooks: viewModel.popularBooks,
                            booksByGenre: initialBooksByGenre,
                            selectedGenreFromCard: $selectedGenreFromCard,
                            selectedFilter: $selectedFilter
                        )
                    }
                }
            }
            .onAppear {
                initialBooksByGenre = viewModel.booksByGenre
            }
            .sheet(item: $selectedBook) { book in
                BookDetailView(book: book)
                    .onDisappear {
                        selectedGenreFromCard = nil
                        viewModel.searchText = ""
                        showingSuggestions = false
                    }
            }
            .sheet(item: Binding(
                get: { selectedAuthor.map { Author(name: $0) } },
                set: { author in selectedAuthor = author?.name }
            )) { author in
                AuthorBooksView(author: author.name, books: viewModel.books.filter { $0.author == author.name })
            }
        }
    }
}