//
//  String.swift
//  Podcast
//
//  Created by Victor Chang on 05/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation

extension String {
	func toSecureHTTPS() -> String {
		return self.contains("https") ? self : self.replacingOccurrences(of: "https", with: "https")
	}
}
