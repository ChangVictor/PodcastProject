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
		
		setupPlayerDetailsView()
		}
	
	//MARK:- Setup Functions
	let playerDetailsView = PlayerDetailsView.initFromNib()
	var maximizedTopAnchorConstraint: NSLayoutConstraint!
	var minimizedTopAnchorConstraint: NSLayoutConstraint!
	var bottomAnchorConstraint: NSLayoutConstraint!
	
	@objc func minimizePlayerDetails() {
		print("playerDetails Minimized")
		
		maximizedTopAnchorConstraint.isActive = false
		bottomAnchorConstraint.constant = view.frame.height
		minimizedTopAnchorConstraint.isActive = true
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
			self.tabBar.transform = .identity // devuelve la tabbar escondida con el CGAffineTransform en maximizePlayerDetails
			self.playerDetailsView.maximizedStackView.alpha = 0
			self.playerDetailsView.miniPlayerView.alpha = 1 
		})
	}
	
	func maximizePlayerDetails(episode: Episode?) {
		print("playerDetails Maximized")
		
		minimizedTopAnchorConstraint.isActive = false
		maximizedTopAnchorConstraint.isActive = true
		maximizedTopAnchorConstraint.constant = 0
		
		bottomAnchorConstraint.constant = 0
		
		if episode != nil {
			playerDetailsView.episode = episode
		}
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
			
			self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
			
			self.playerDetailsView.maximizedStackView.alpha = 1
			self.playerDetailsView.miniPlayerView.alpha = 0 // Hace transparende al miniStackView mientras esta maximized
		})
	}
	
	fileprivate func setupPlayerDetailsView() {
		print("Setting up PlayerDetailsView")
		
		view.insertSubview(playerDetailsView, belowSubview: tabBar)
		// Es necesario agregar el addSubview antes de los layouts, sino crashea /?
		//AutoLayout
		playerDetailsView.translatesAutoresizingMaskIntoConstraints = false //enables autolayout
		
		maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height)
		maximizedTopAnchorConstraint.isActive = true
		
		bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
		bottomAnchorConstraint.isActive = true
		
		minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//		minimizedTopAnchorConstraint.isActive = true
		
		playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
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

