//
//  PodcastSearchController.swift
//  Podcast
//
//  Created by Victor Chang on 03/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Alamofire

class PodcastSearchController: UITableViewController, UISearchBarDelegate {
	
	var podcasts = [
		Podcast(trackName: "Lets Build That App", artistName: "Brian Voong"),
		Podcast(trackName: "Some Podcast", artistName: "Some Author"),
		]
	let cellId = "cellId"
	
	// Implementar UISerachController
	let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupSearchBar()
		setupTableView()

	}
	
	//MARK:- Setups
	
	fileprivate func setupSearchBar() {
		
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
			self.podcasts = podcasts
			self.tableView.reloadData()
		}
	}

	
	fileprivate func setupTableView() {
		//1. Registar la celda del tableView
//		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
		
		let nib = UINib(nibName: "PodcastCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: cellId)
		
	}
	
	//MARK:- UITableView
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return podcasts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
		
		let podcast = self.podcasts[indexPath.row]
		cell.podcast = podcast
		
//		let podcast = self.podcasts[indexPath.row]
//		cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
//		cell.textLabel?.numberOfLines = -1
//		cell.imageView?.image = #imageLiteral(resourceName: "appicon")
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 132
	}
	
}
