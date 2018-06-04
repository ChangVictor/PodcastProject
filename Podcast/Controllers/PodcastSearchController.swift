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
	
	var podcasts = [Podcast]()
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
		definesPresentationContext = true
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
			self.podcasts = podcasts
			self.tableView.reloadData()
		}
	}

	
	fileprivate func setupTableView() {
		// Elimina las lineas entre los Rows
		tableView.tableFooterView = UIView()
		//1. Registar la celda del tableView
//		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
		
		let nib = UINib(nibName: "PodcastCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: cellId)
		
	}
	
	//MARK:- UITableView
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "Please enter a Search Term"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		return label
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 250
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return podcasts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
		
		let podcast = self.podcasts[indexPath.row]
		cell.podcast = podcast

		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 132
	}
	
}
