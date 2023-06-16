//
//  SongResponse.swift
//  myTunesApp
//
//  Created by Baki Uçan on 13.06.2023.
//

// MARK: API RESPONSE

struct SearchResponse: Decodable {
    let results: [Song]
}
