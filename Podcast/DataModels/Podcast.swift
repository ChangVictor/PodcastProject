//
//  Podcast.swift
//  Podcast
//
//  Created by Victor Chang on 03/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
	
	var trackName: String?
	var artistName: String?
	var artworkUrl600: String?
	var trackCount: Int?
	var feedUrl: String?
	
}
