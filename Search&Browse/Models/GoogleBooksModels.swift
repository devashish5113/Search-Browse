//
//  GoogleBooksModels.swift
//  Search&Browse
//
//  Created by Devashish Upadhyay on 19/03/25.
//

import Foundation

struct GoogleBooksResponse: Codable {
    let items: [BookItem]?
    let totalItems: Int
    let kind: String
}

struct BookItem: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
    
    var book: Book {
        Book(
            id: UUID(),
            title: volumeInfo.title,
            author: volumeInfo.authors?.first ?? "Unknown Author",
            isbn: volumeInfo.industryIdentifiers?.first?.identifier ?? "",
            genre: volumeInfo.categories?.first ?? "Uncategorized",
            publicationYear: Int(volumeInfo.publishedDate?.prefix(4) ?? "0") ?? 0,
            availability: .available,
            reservedBy: nil,
            imageURL: volumeInfo.imageLinks?.thumbnail
        )
    }
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let language: String?
}

struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}