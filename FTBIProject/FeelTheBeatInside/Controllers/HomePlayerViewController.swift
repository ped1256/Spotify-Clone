//
//  HomePlayerViewController.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 21/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

class HomePlayerViewController: UIViewController, UISearchBarDelegate {
    
    private var artist: ArtistViewModel?{
        didSet {
            updateUI()
        }
    }
    
    private var activePlayer: TrackViewModel? {
        didSet {
            updateUI()
        }
    }

   private var shouldShowArtistImage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.1782757183, green: 0.193023016, blue: 0.2144471764, alpha: 1)
        buildUI()
    }
    
    private var playerControl: PlayerControl? {
        didSet {
            NotificationCenter.default.post(Notification(name: .playItemNotificationName, object: playerControl, userInfo: nil))
        }
    }
    
    private var progressView = TrackProgressView()
    private let darkView = UIView()
    
    private lazy var tableView: UITableView = {
        let t = UITableView()
        
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = .clear
        t.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.identifier)
        t.tableFooterView = UIView()
        t.delegate = self
        t.dataSource = self
        
        return t
    }()
    
    private let emptyArtistimageView = UIImageView()
    private let backgroundBlurView = UIBlurEffect()
    private let albumImageView = UIImageView()
    
    private lazy var transparentPlayImageView: UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHidden = true
        l.isUserInteractionEnabled = true
        l.image = UIImage(named: "white_button_play")
        return l
    }()
    
    private lazy var nextTrackButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "next_track_icon"), for: .normal)
        b.isHidden = true
        b.addTarget(self, action: #selector(nextTrackAction), for: .touchUpInside)
        return b
    }()
    
    private lazy var previousTrackButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "previous_track_icon"), for: .normal)
        b.isHidden = true
        b.addTarget(self, action: #selector(previousTrackAction), for: .touchUpInside)
        return b
    }()
    
    private var searchArtistButton = SearchArtistsButton()
    
    private let artistNameLabel = UILabel()
    
    private let trackNameLabel: UILabel = {
        let t = UILabel()
        
        t.textColor = UIColor.white.withAlphaComponent(0.8)
        t.font = UIFont.systemFont(ofSize: 14)
        t.isHidden = true
        
        return t
    }()
    
    private lazy var searchController: UISearchController = {
        
        let searchResultController = SearchResultViewController()
        
        searchResultController.viewDisapear = { [weak self] in
            self?.darkView.isHidden = true
            
            if let count = self?.artist?.tracks?.count, count == 0 {
                self?.searchArtistButton.alpha = 1.0
            } else {
                self?.searchArtistButton.isHidden = true
            }
        }
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = searchResultController
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.3227999919, green: 0.3495026053, blue: 0.3882948697, alpha: 1)
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = #colorLiteral(red: 0.1782757183, green: 0.193023016, blue: 0.2144471764, alpha: 1)
            textfield.textColor = .gray
            
            textfield.attributedPlaceholder = NSAttributedString(string: "Procurar Artistas", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
            textfield.keyboardAppearance = UIKeyboardAppearance.dark
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)], for: .normal)
        
        if let searchbarCancelButton = searchController.searchBar.value(forKey: "_cancelButton") as? UIButton {
            searchbarCancelButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        }
        
        searchResultController.delegate = self
        
        return searchController
    }()
    
    private func buildUI() {
        buildNavigation()
        buildArtistInfo()
        buildTableView()
        buildControlButtons()
        buildDarkView()
        buildSearchButton()
    }
    
    private func buildNavigation() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        
        let item = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarAction))
        item.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1782757183, green: 0.193023016, blue: 0.2144471764, alpha: 1)
        navigationItem.title = "Artistas"
        navigationItem.setRightBarButton(item, animated: true)
    }
    
    private func buildSearchButton() {
        self.view.addSubview(searchArtistButton)
        searchArtistButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        searchArtistButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        searchArtistButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        searchArtistButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        searchArtistButton.rightAnchor.constraint(equalTo: self.view.leftAnchor, constant: -100).isActive = true
        searchArtistButton.addTarget(self, action: #selector(searchBarAction), for: .touchUpInside)
    }
    
    private func buildDarkView() {
        darkView.frame = self.view.frame
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        darkView.isHidden = true
        
        self.view.addSubview(darkView)
    }
    
    private func buildArtistInfo() {
        view.addSubview(albumImageView)
        view.addSubview(artistNameLabel)
        view.addSubview(trackNameLabel)
        
        
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3.5).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3.5).isActive = true
        albumImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        if UIScreen.isIphoneX() {
            albumImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88).isActive = true
        } else {
            albumImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        }
        
        albumImageView.clipsToBounds = true
        albumImageView.backgroundColor = #colorLiteral(red: 0.3227999919, green: 0.3495026053, blue: 0.3882948697, alpha: 1)
        albumImageView.isHidden = true
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.leftAnchor.constraint(equalTo: albumImageView.rightAnchor, constant: 20).isActive = true
        artistNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -65).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: albumImageView.topAnchor, constant: 15).isActive = true
        artistNameLabel.textColor = .white
        artistNameLabel.isHidden = true
        
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.leftAnchor.constraint(equalTo: albumImageView.rightAnchor, constant: 20).isActive = true
        trackNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -65).isActive = true
        trackNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 10).isActive = true

    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.artistNameLabel.text = self.artist?.name
            self.albumImageView.image = self.artist?.image
            self.artistNameLabel.isHidden = false
            self.albumImageView.isHidden = false
            self.emptyArtistimageView.isHidden = true
            self.tableView.reloadData()
            
            guard let player = self.activePlayer else { return }
            
            if player.isPlaying {
                if self.shouldShowArtistImage {
                    self.albumImageView.image = self.activePlayer?.image
                }
                
                self.trackNameLabel.text = self.activePlayer?.name
                self.transparentPlayImageView.isHidden = false
                self.nextTrackButton.isHidden = false
                self.albumImageView.image = self.activePlayer?.image
                self.previousTrackButton.isHidden = false
                self.progressView.isHidden = false
                self.trackNameLabel.isHidden = false
                self.transparentPlayImageView.image = UIImage(named: "white_button_pause")
            } else {
                self.transparentPlayImageView.image = UIImage(named: "white_button_play")
            }
        }
    }
    
    private func buildTableView() {
        self.view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 15).isActive = true
        tableView.separatorStyle = .none
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func buildProgressView() {
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.leftAnchor.constraint(equalTo: previousTrackButton.rightAnchor, constant: 10).isActive = true
        progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        progressView.layer.cornerRadius = 2
        progressView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressView.centerYAnchor.constraint(equalTo: previousTrackButton.centerYAnchor).isActive = true
    }
    
    private func buildControlButtons() {
        view.addSubview(transparentPlayImageView)
        view.addSubview(nextTrackButton)
        view.addSubview(previousTrackButton)
        
        transparentPlayImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        transparentPlayImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        transparentPlayImageView.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor).isActive = true
        transparentPlayImageView.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor).isActive = true
        
        transparentPlayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pauseAndPlayTrackAction)))
        
        previousTrackButton.leftAnchor.constraint(equalTo: artistNameLabel.leftAnchor).isActive = true
        previousTrackButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        previousTrackButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        previousTrackButton.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: -10).isActive = true
        
        buildProgressView()
        
        nextTrackButton.leftAnchor.constraint(equalTo: progressView.rightAnchor, constant: 10).isActive = true
        nextTrackButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        nextTrackButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        nextTrackButton.bottomAnchor.constraint(equalTo: previousTrackButton.bottomAnchor).isActive = true
        
    }
    
    @objc private func searchBarAction(_ sender: Any) {
        self.darkView.isHidden = false
        self.searchArtistButton.alpha = 0.3
        present(searchController, animated: true, completion: nil)
    }
    
    @objc private func nextTrackAction() {
        controlButtonActions(state: .next)
    }
    
    @objc private func previousTrackAction() {
        controlButtonActions(state: .previous)
    }
    
    private func controlButtonActions(state: PlayerStates) {
        guard let activePlayer = activePlayer, activePlayer.trackPosition > 0, activePlayer.trackPosition < 11 else { return }
        
        var nextPlayer = activePlayer
        
        if state == .next  {
            guard let player = artist?.tracks?[activePlayer.trackPosition + 1] else { return }
            nextPlayer = player
            nextPlayer.trackPosition = activePlayer.trackPosition + 1
        } else if state == .previous {
            guard let player = artist?.tracks?[activePlayer.trackPosition - 1] else { return }
            nextPlayer = player
            nextPlayer.trackPosition = activePlayer.trackPosition - 1
        }

        guard let uri = nextPlayer.uri else { return }
        clearPlayerStates()
        
        nextPlayer.isPlaying = true
        progressView.start(track: nextPlayer)
        self.activePlayer = nextPlayer
        let playerControl = PlayerControl.init(isPlaying: nextPlayer.isPlaying, state: .play, trackURI: uri)
        self.playerControl = playerControl
    }
    
    @objc private func pauseAndPlayTrackAction() {
        guard let activePlayer = activePlayer, let uri = activePlayer.uri else { return }
        
        let state = activePlayer.isPlaying ? PlayerStates.pause : PlayerStates.resume
        let playerControl = PlayerControl.init(isPlaying: activePlayer.isPlaying, state: state, trackURI: uri)
        activePlayer.isPlaying = state == .pause ? false : true
        
        var progressState: ProgressState = .paused
        
        if state == .resume {
            progressState = .animating
        }

        progressView.changeState(state: progressState)
        
        self.activePlayer = activePlayer
        self.playerControl = playerControl
    }
    
    private func clearPlayerStates() {
        self.artist?.tracks?.forEach({ track in
            track.isPlaying = false
        })
    }
}

extension HomePlayerViewController: SearchResultViewControllerDelegate {
    func didSelectArtist(artist: ArtistViewModel) {
        guard let id = artist.id else { return }
        
        NetworkOperation.getArtistTracks(path: id) { result in
            let tracksViewModel = result.tracks.map({ TrackViewModel(with: $0) })
            self.artist?.tracks = tracksViewModel
            
            self.updateUI()
        }
        
        self.artist = artist
    }
}

extension HomePlayerViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tracks = artist?.tracks else { return 0}
        guard tracks.count <= 10 else  { return 10 }
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.artist?.tracks?.forEach({ track in
            track.isPlaying = false
        })
        
        guard let trackViewModel = self.artist?.tracks?[indexPath.row] else { return }
        guard let uri = trackViewModel.uri else { return }
        
        let playerControl = PlayerControl(isPlaying: trackViewModel.isPlaying, state: .play, trackURI: uri)
        self.playerControl = playerControl
        trackViewModel.isPlaying = true
        shouldShowArtistImage = false
        trackViewModel.trackPosition = indexPath.row
        
        self.activePlayer = trackViewModel
        progressView.start(track: trackViewModel)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier, for: indexPath) as? TrackTableViewCell else { return UITableViewCell() }
        
        guard let trackViewModel = self.artist?.tracks?[indexPath.row] else { return UITableViewCell() }
        
        cell.trackCount = indexPath.row + 1
        cell.trackViewModel = trackViewModel
        
        return cell
    }
    
}
