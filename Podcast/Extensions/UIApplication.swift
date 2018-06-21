//
//  UIApplication.swift
//  Podcast
//
//  Created by Victor Chang on 20/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

extension UIApplication {
	static func mainTabBarController() -> MainTabBarController? {
		
		return shared.keyWindow?.rootViewController as? MainTabBarController
	}
}
