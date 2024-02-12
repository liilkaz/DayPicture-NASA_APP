//
//  SearchModel.swift
//  DayPic
//
//  Created by Лилия Феодотова on 08.02.2024.
//

import Foundation

// MARK: - SearchModel
struct SearchModel: Codable {
    let collection: Collection?
}

// MARK: - Collection
struct Collection: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let data: [Datum]?
    let links: [ItemLink]?
}

// MARK: - Datum
struct Datum: Codable {
    let title: String?
    let description: String?
}

// MARK: - ItemLink
struct ItemLink: Codable {
    let href: String?
}
