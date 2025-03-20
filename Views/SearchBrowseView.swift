import SwiftUI

struct SearchBrowseView: View {
    @State private var searchText = ""
    @State private var searchResults: [Book] = []
    @State private var popularBooks: [Book] = []
    @State private var yourBooks: [Book] = []
    @State private var selectedBook: Book? = nil
    @State private var showBookDetail = false
    @StateObject private var viewModel = BookSearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for books", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            if !newValue.isEmpty {
                                searchBooks(query: newValue)
                            } else {
                                searchResults = []
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Content
                if !searchText.isEmpty && !searchResults.isEmpty {
                    SearchResultsView(
                        searchResults: searchResults,
                        selectedBook: $selectedBook,
                        showBookDetail: $showBookDetail
                    )
                } else if !searchText.isEmpty && searchResults.isEmpty {
                    VStack {
                        Spacer()
                        Text("No books found")
                            .font(.headline)
                        Spacer()
                    }
                } else {
                    // Default Browse View
                    ScrollView {
                        VStack(alignment: .leading) {
                            // Your Books Section
                            if !yourBooks.isEmpty {
                                Text("Your Books")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(yourBooks) { book in
                                            BookCardView(
                                                book: book,
                                                onTap: {
                                                    withAnimation {
                                                        selectedBook = book
                                                        showBookDetail = true
                                                    }
                                                }
                                            )
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Popular Books Section
                            Text("Popular Books")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(popularBooks) { book in
                                        BookCardView(
                                            book: book,
                                            onTap: {
                                                withAnimation {
                                                    selectedBook = book
                                                    showBookDetail = true
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search & Browse")
            .sheet(isPresented: $showBookDetail, onDismiss: {
                selectedBook = nil
                showBookDetail = false
            }) {
                if let book = selectedBook {
                    BookDetailView(book: book)
                }
            }
            .onAppear {
                loadSampleData()
            }
        }
    }
    
    private func searchBooks(query: String) {
        searchResults = popularBooks.filter {
            $0.title.lowercased().contains(query.lowercased()) ||
            $0.author.lowercased().contains(query.lowercased())
        }
    }
    
    private func loadSampleData() {
        popularBooks = [
            Book(id: UUID(), title: "1984", author: "George Orwell", isbn: "9780451524935", genre: "Fiction", publicationYear: 1949, availability: .available, reservedBy: nil),
            Book(id: UUID(), title: "The Lean Startup", author: "Eric Ries", isbn: "9780307887894", genre: "Business", publicationYear: 2011, availability: .available, reservedBy: nil),
            Book(id: UUID(), title: "To Kill a Mockingbird", author: "Harper Lee", isbn: "9780061120084", genre: "Fiction", publicationYear: 1960, availability: .issued, reservedBy: nil)
        ]
        
        yourBooks = [
            Book(id: UUID(), title: "Atomic Habits", author: "James Clear", isbn: "9780735211292", genre: "Self-Help", publicationYear: 2018, availability: .issued, reservedBy: nil),
            Book(id: UUID(), title: "Sapiens", author: "Yuval Noah Harari", isbn: "9780062316097", genre: "History", publicationYear: 2014, availability: .available, reservedBy: nil)
        ]
    }
}