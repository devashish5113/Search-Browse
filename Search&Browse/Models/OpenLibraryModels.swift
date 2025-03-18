//
//  OpenLibraryModels.swift
//  Search&Browse
//
//  Created by Devashish Upadhyay on 19/03/25.
//

import Foundation

struct OpenLibraryResponse: Codable {
    let works: [OpenLibraryBook]?
    let docs: [OpenLibraryBook]?
    let numFound: Int?
    
    enum CodingKeys: String, CodingKey {
        case works
        case docs
        case numFound = "num_found"
    }
    
    var allBooks: [OpenLibraryBook] {
        if let works = works {
            return works
        } else if let docs = docs {
            return docs
        }
        return []
    }
}

struct OpenLibraryBook: Codable {
    let key: String
    let title: String
    let authorName: [String]?
    let authors: [OpenLibraryAuthor]?
    let firstPublishYear: Int?
    let isbn: [String]?
    let subject: [String]?
    let coverI: Int?
    
    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorName = "author_name"
        case authors
        case firstPublishYear = "first_publish_year"
        case isbn
        case subject
        case coverI = "cover_i"
    }
    
    var book: Book {
        let coverId = if let coverI = coverI {
            String(coverI)
        } else {
            key.components(separatedBy: "/").last ?? ""
        }
        let imageURL = "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg"
        
        let authorName = if let firstAuthor = authorName?.first {
            firstAuthor
        } else if let firstAuthor = authors?.first?.name {
            firstAuthor
        } else {
            "Unknown Author"
        }
        
        return Book(
            id: UUID(),
            title: title,
            author: authorName,
            isbn: isbn?.first ?? "",
            genre: subject?.first ?? "Uncategorized",
            publicationYear: firstPublishYear ?? 0,
            availability: .available,
            reservedBy: nil,
            imageURL: imageURL
        )
    }
}

struct OpenLibraryAuthor: Codable {
    let name: String
}