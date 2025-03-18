//
//  BookSearchViewModel.swift
//  Search&Browse
//
//  Created by Devashish Upadhyay on 19/03/25.
//

import Foundation
import Combine

class BookSearchViewModel: ObservableObject {
    @Published var books: [Book] = [
        Book(id: UUID(), title: "The Design of Everyday Things", author: "Don Norman", isbn: "978-0465050659", genre: "Technology", publicationYear: 2013, availability: .available, reservedBy: nil, imageURL: "https://covers.openlibrary.org/b/id/8479576-L.jpg"),
        Book(id: UUID(), title: "Dune", author: "Frank Herbert", isbn: "978-0441172719", genre: "Fiction", publicationYear: 1965, availability: .available, reservedBy: nil, imageURL: "https://covers.openlibrary.org/b/id/8474557-L.jpg"),
        Book(id: UUID(), title: "A Brief History of Time", author: "Stephen Hawking", isbn: "978-0553380163", genre: "Science", publicationYear: 1988, availability: .available, reservedBy: nil, imageURL: "https://covers.openlibrary.org/b/id/8406786-L.jpg"),
        Book(id: UUID(), title: "1776", author: "David McCullough", isbn: "978-0743226721", genre: "History", publicationYear: 2005, availability: .available, reservedBy: nil, imageURL: "https://covers.openlibrary.org/b/id/8741937-L.jpg"),
        Book(id: UUID(), title: "Zero to One", author: "Peter Thiel", isbn: "978-0804139298", genre: "Business", publicationYear: 2014, availability: .available, reservedBy: nil, imageURL: "https://covers.openlibrary.org/b/id/8426139-L.jpg")
    ]
    
    var booksByGenre: [String: [Book]] {
        Dictionary(grouping: books, by: { $0.genre })
    }
    
    var availableGenres: [String] {
        Array(Set(books.map { $0.genre })).sorted()
    }
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var selectedGenre: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        config.allowsCellularAccess = true
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true
        config.urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
        return URLSession(configuration: config)
    }()
    
    func searchBooks() {
        guard !searchText.isEmpty else { 
            books = []
            return 
        }
        isLoading = true
        errorMessage = nil
        
        let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://openlibrary.org/search.json?q=\(query)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        urlSession.dataTaskPublisher(for: url)
            .retry(3)
            .delay(for: .seconds(1), scheduler: DispatchQueue.global())
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                switch response.statusCode {
                case 200: return output.data
                case 401: throw URLError(.userAuthenticationRequired)
                case 429: throw URLError(.networkConnectionLost)
                case 503: throw URLError(.badServerResponse)
                default: throw URLError(.badServerResponse)
                }
            }
            .decode(type: OpenLibraryResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    if let decodingError = error as? DecodingError {
                        self?.errorMessage = "Failed to decode response: \(decodingError.localizedDescription)"
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            self?.errorMessage = "No internet connection. Please check your network settings."
                        case .timedOut:
                            self?.errorMessage = "Request timed out. Please try again."
                        case .userAuthenticationRequired:
                            self?.errorMessage = "API key authentication failed."
                        case .badServerResponse:
                            self?.errorMessage = "Service is temporarily unavailable. Please try again later."
                        default:
                            self?.errorMessage = "Network error: \(urlError.localizedDescription)"
                        }
                    } else {
                        self?.errorMessage = "Failed to fetch books: \(error.localizedDescription)"
                    }
                }
            } receiveValue: { [weak self] response in
                let books = response.allBooks.map { $0.book }
                DispatchQueue.main.async {
                    self?.books = books
                    if books.isEmpty {
                        self?.errorMessage = "No books found for your search"
                    } else {
                        self?.errorMessage = nil
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchBooksByGenre(_ genre: String) {
        isLoading = true
        errorMessage = nil
        
        let query = genre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://openlibrary.org/subjects/\(query.lowercased()).json"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        urlSession.dataTaskPublisher(for: url)
            .retry(3)
            .delay(for: .seconds(1), scheduler: DispatchQueue.global())
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                switch response.statusCode {
                case 200: return output.data
                case 401: throw URLError(.userAuthenticationRequired)
                case 429: throw URLError(.networkConnectionLost)
                case 503: throw URLError(.badServerResponse)
                default: throw URLError(.badServerResponse)
                }
            }
            .decode(type: OpenLibraryResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    if let decodingError = error as? DecodingError {
                        print("Decoding Error: \(decodingError)")
                        self?.errorMessage = "Failed to decode response: \(decodingError.localizedDescription)"
                    } else if let urlError = error as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            self?.errorMessage = "No internet connection. Please check your network settings."
                        case .timedOut:
                            self?.errorMessage = "Request timed out. Please try again."
                        case .userAuthenticationRequired:
                            self?.errorMessage = "API key authentication failed."
                        case .badServerResponse:
                            self?.errorMessage = "Service is temporarily unavailable. Please try again later."
                        default:
                            self?.errorMessage = "Network error: \(urlError.localizedDescription)"
                        }
                    } else {
                        self?.errorMessage = "Failed to fetch books: \(error.localizedDescription)"
                    }
                }
            } receiveValue: { [weak self] response in
                let books = response.docs?.map { $0.book } ?? []
                DispatchQueue.main.async {
                    self?.books = books
                    if books.isEmpty {
                        self?.errorMessage = "No books found"
                    } else {
                        self?.errorMessage = nil
                    }
                }
            }
            .store(in: &cancellables)
    }
}