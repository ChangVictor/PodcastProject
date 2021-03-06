//
//  PlayerDetailsView.swift
//  Podcast
//
//  Created by Victor Chang on 07/06/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
	
	var episode: Episode! {
		didSet {
			miniTitleLabel.text = episode.title
			episodeTitleLabel.text = episode.title
			authorLabel.text = episode.author
			
			playEpisode()
			
			guard let url = URL(string: episode.imageUrl ?? "") else { return }
			episodeImageView.sd_setImage(with: url)
			miniEpisodeImageView.sd_setImage(with: url)
		}
	}
	
	fileprivate func playEpisode() {
		print("Trying to play episode at url: ", episode.streamUrl)
		
		guard let url = URL(string: episode.streamUrl) else { return }
		let playerItem = AVPlayerItem(url: url)
		player.replaceCurrentItem(with: playerItem)
		player.play()
	}
	
	var player: AVPlayer = {
		let avPlayer = AVPlayer()
		avPlayer.automaticallyWaitsToMinimizeStalling = false
		return avPlayer
	}()
	
	fileprivate func observePlayerCurrentTime() {
		let interval = CMTimeMake(1, 2)
		player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
			self?.currentTimeLabel.text = time.toDisplayString()
			let durationTime = self?.player.currentItem?.duration
			self?.durationLabel.text = durationTime?.toDisplayString()
			
			self?.updateCurrentTimeSlider()
		}
	}
	
	fileprivate func updateCurrentTimeSlider() {
		let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
		let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1,1))
		let percentage = currentTimeSeconds / durationSeconds
		
		self.currentTimeSlider.value = Float(percentage)
	}
	
	var panGesture: UIPanGestureRecognizer!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupGestures()
		
		observePlayerCurrentTime()
		
		let time = CMTime(value: 1, timescale: 3) // Monitorea el comienzo del player cuando arranca (?)
		let times = [NSValue(time: time)]
		
		// player has a reference to self
		// self has a reference to player
		player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
			print("Episode started playing")
			self?.enlargeEpisodeImageView()
		}
	}
	
	fileprivate func setupGestures() {
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		miniPlayerView.addGestureRecognizer(panGesture)
		
		maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
		
	}
	
	@objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
		if gesture.state == .changed {
			let translation = gesture.translation(in: superview)
			maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
		} else if gesture.state == .ended {
			let translation = gesture.translation(in: superview)
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.maximizedStackView.transform = .identity
				if translation.y > 50 {
					UIApplication.mainTabBarController()?.minimizePlayerDetails()
				}
			})
		}
	}
		
	static func initFromNib() -> PlayerDetailsView {
		return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
	}
	
	deinit {
		print("PlayerDetailView memory being reclaimed...")
	}
	
	fileprivate func enlargeEpisodeImageView() {
		UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.episodeImageView.transform = .identity
		})
	}
	
	fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
	
	fileprivate func shrinkEpisodeImageView() {
		UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.episodeImageView.transform = self.shrunkenTransform
		})
	}
	
	
	// MARK:- IB Actions & Outlets
	
	@IBOutlet weak var miniEpisodeImageView: UIImageView!
	@IBOutlet weak var miniTitleLabel: UILabel!
	@IBOutlet weak var miniPlayPauseButton: UIButton! {
		didSet {
			miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
			miniPlayPauseButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
		}
	}
	
	@IBOutlet weak var miniFastForwardButton: UIButton! {
		didSet {
			miniFastForwardButton.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
		}
	}
	
	@IBOutlet weak var miniPlayerView: UIStackView!
	@IBOutlet weak var maximizedStackView: UIStackView!
	
	@IBOutlet weak var currentTimeLabel: UILabel!
	
	@IBOutlet weak var currentTimeSlider: UISlider!
	@IBOutlet weak var durationLabel: UILabel!
	
	@IBOutlet weak var episodeImageView: UIImageView! {
		didSet {
			episodeImageView.layer.cornerRadius = 5
			episodeImageView.clipsToBounds = true
			episodeImageView.transform = shrunkenTransform
		}
		
	}
	
	@IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
		let percentage = currentTimeSlider.value
		guard let duration = player.currentItem?.duration else { return }
		let durationInSeconds = CMTimeGetSeconds(duration)
		let seekTimeInSeconds = Float64(percentage) * durationInSeconds
		let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, Int32(NSEC_PER_SEC)) // Int32(NSEC_PER_SEC) -> escala de number of seconds per seconds... si asignas valor 1 sigue funcionando...
		
		player.seek(to: seekTime)
	}
	
	@IBAction func handleFastForward(_ sender: Any) {
		seekToCurrentTime(delta: 15)
	}
	
	@IBAction func handleRewind(_ sender: Any) {
		seekToCurrentTime(delta: -15)
	}
	
	fileprivate func seekToCurrentTime(delta: Int64) {
		let fifteenSeconds = CMTimeMake(delta, 1) // el 1 es el NSEC_PER_SEC
		let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
		player.seek(to: seekTime)
	}
	
	@IBAction func handleVolumeChange(_ sender: UISlider) {
		
		player.volume = sender.value
		
	}
	
	@IBOutlet weak var playPauseButton: UIButton! {
		didSet {
			
			playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
		}
	}
	
	@objc func handlePlayPause() {
		print("Trying to play & pause")
		if player.timeControlStatus == .paused {
			player.play()
			playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
			enlargeEpisodeImageView()
		} else {
			player.pause()
			playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
			shrinkEpisodeImageView()
		}
	}
	
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var episodeTitleLabel: UILabel! {
		didSet {
			episodeTitleLabel.numberOfLines = 2
		}
	}
	
	@IBAction func handleDismiss (_ sender: Any) {
//		self.removeFromSuperview()
		let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
		mainTabBarController?.minimizePlayerDetails()
	}
	
}
