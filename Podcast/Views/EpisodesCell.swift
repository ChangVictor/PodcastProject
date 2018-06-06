//
//  EpisodesCell.swift
//  Podcast
//
//  Created by Victor Chang on 05/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class EpisodesCell: UITableViewCell {

	var episode: Episode! {
		didSet{
			titleLabel.text = episode.title
			descriptionLabel.text = episode.description
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			dateLabel.text = dateFormatter.string(from: episode.pubDate)
			
			let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
			episodeImageView.sd_setImage(with: url)
		}
	}
	
	@IBOutlet weak var descriptionLabel: UILabel! {
		didSet{
			descriptionLabel.numberOfLines = 2
		}
	}
	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.numberOfLines = 2
		}
	}
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var episodeImageView: UIImageView!
	
}
