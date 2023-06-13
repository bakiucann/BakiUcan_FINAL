//
//  Song.swift
//  myTunesApp
//
//  Created by Baki Uçan on 13.06.2023.
//

struct Song: Decodable {
    let wrapperType: String
    let kind: String?
    let artistId: Int
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let trackName: String?
    let collectionName: String?
    let artistViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: String
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
}

