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
		
		// Para iniciar la app con una busqueda predeterminada
		searchBar(searchController.searchBar, textDidChange: "NPR")
	}
	
	//MARK:- Setups
	
	fileprivate func setupSearchBar() {
		
		self.definesPresentationContext = true
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
		definesPresentationContext = true
	}
	
	var timer: Timer?
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
			APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
				self.podcasts = podcasts
				self.tableView.reloadData()
			}
		})
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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let episodesController = EpisodesController()
		let podcast = self.podcasts[indexPath.row]
		episodesController.podcast = podcast
		navigationController?.pushViewController(episodesController, animated: true)
		
	}
	// Llama a un view.xib que contiene un loading
	var podcastSearchView = Bundle.main.loadNibNamed("PodcastsSearchingView", owner: self, options: nil)?.first as? UIView
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
			return podcastSearchView
		}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "Please enter a Search Term"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		return label
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
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
