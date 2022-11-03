//
//  YoutubeSearchResponse.swift
//  Netflix
//
//  Created by Vladislavs on 03/11/2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [YoutubeSearchResult]
}

struct YoutubeSearchResult: Codable {
    let id: YoutubeId
}

struct YoutubeId: Codable {
    let kind: String
    let videoId: String
}
