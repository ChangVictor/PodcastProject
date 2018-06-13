//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Victor Chang on 03/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Tamaño del title en el navBar
		UINavigationBar.appearance().prefersLargeTitles = true
		
		tabBar.tintColor = .purple
		
		setupViewControllers()
		
		setupPlayerDetailView()
		
	}
	
	//MARK:- Setup Functions
	
	fileprivate func setupPlayerDetailView() {
		
	}

	
	func setupViewControllers() {
		
		viewControllers = [
			generateNavigationController(with: PodcastSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
			generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
			generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads") )
		]
	}
	
	//MARK:- Helper Functions
	
	fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
		
		let navController = UINavigationController(rootViewController: rootViewController)
		// Tamaño del title en el navBar
//		navController.navigationBar.prefersLargeTitles = true
		// Mostrar el title en el navBar
		rootViewController.navigationItem.title = title
		navController.tabBarItem.title = title
		navController.tabBarItem.image = image
		
		return navController
	}
	
	
	
}

