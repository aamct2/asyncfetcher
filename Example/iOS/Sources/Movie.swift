//
//  Movie.swift
//  iOS Example
//
//  Created by Aaron McTavish on 29/04/2018.
//  Copyright © 2018 Aaron McTavish. All rights reserved.
//

import Foundation


struct Movie: Codable {

    let artworkURL: URL
    let name: String

    enum CodingKeys: String, CodingKey {
        case artworkURL = "artworkUrl100"
        case name
    }

}
