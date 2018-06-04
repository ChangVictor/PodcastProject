//
//  PodcastCell.swift
//  Podcast
//
//  Created by Victor Chang on 03/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
	
	@IBOutlet weak var podcastImageView: UIImageView!
	@IBOutlet weak var trackNameLabel: UILabel!
	@IBOutlet weak var episodeCountLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!
	
	var podcast: Podcast! {
		didSet {
			trackNameLabel.text = podcast.trackName
			artistNameLabel.text = podcast.artistName
		}
	}
	
}
