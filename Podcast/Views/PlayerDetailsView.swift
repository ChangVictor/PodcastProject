//
//  PlayerDetailsView.swift
//  Podcast
//
//  Created by Victor Chang on 07/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class PlayerDetailsView: UIView {
	
	var episode: Episode! {
		didSet {
			
			episodeTitleLabel.text = episode.title
			
			guard let url = URL(string: episode.imageUrl ?? "") else { return }
			episodeImageView.sd_setImage(with: url)
			
		}
	}
	
	@IBOutlet weak var episodeImageView: UIImageView!
	@IBOutlet weak var episodeTitleLabel: UILabel!
	
	
	@IBAction func handleDismiss (_ sender: Any) {
		
		self.removeFromSuperview()
		
	}
	
}
