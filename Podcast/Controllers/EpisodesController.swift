//
//  EpisodesController.swift
//  Podcast
//
//  Created by Victor Chang on 04/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
	
	var podcast: Podcast? {
		didSet {
			navigationItem.title = podcast?.trackName
			
			fetchEpisodes()
		}
	}
	
	fileprivate func fetchEpisodes() {
		print("Looking for episodes al url: ", podcast?.feedUrl ?? "")
		
		guard let feedUrl = podcast?.feedUrl else { return }
		
		APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
			self.episodes = episodes
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	fileprivate let cellId = "cellId"
	
	var episodes = [Episode]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTableView()
		
	}
	
	//MARK:- Setups
	
	fileprivate func setupTableView() {

		let nib = UINib(nibName: "EpisodesCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: cellId)
		tableView.tableFooterView = UIView()
		
	}
	
	//MARK:- UITableView
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return episodes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodesCell
		let episode = episodes[indexPath.row]
		cell.episode = episode
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 132
		
	}
	
}
