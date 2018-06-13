//
//  CMTime.swift
//  Podcast
//
//  Created by Victor Chang on 11/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import AVKit


extension CMTime {
	
	func toDisplayString() -> String {
		
		let totalSeconds = Int(CMTimeGetSeconds(self))
		let seconds = totalSeconds % 60
		let minutes = totalSeconds / 60
		let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
		return timeFormatString
		
	}
	
} 
