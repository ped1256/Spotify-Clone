//
//  SearchResultViewController.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 21/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

protocol SearchResultViewControllerDelegate {
    func didSelectArtist(artist: ArtistViewModel)
}

class SearchResultViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    var delegate: SearchResultViewControllerDelegate?
    
    public var viewDisapear: (() -> ())?
    
    private var artists: [ArtistViewModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    private func buildUI() {
        self.view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ArtistTableViewCell.self, forCellReuseIdentifier: ArtistTableViewCell.identifier)
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        NetworkOperation.search(query: text) { result in
            let artistsViewModel = result.artists.items?.compactMap({ ArtistViewModel(with: $0 )})
            self.artists = artistsViewModel
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.artists?.count else { return 0 }
        
        return items
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.identifier, for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
        
        guard let count = self.artists?.count, indexPath.row < count, let artistViewModel = self.artists?[indexPath.row] else { return UITableViewCell() }

        cell.artist = artistViewModel
        
        cell.delegate = { [weak self] artist in
            self?.delegate?.didSelectArtist(artist: artist)
            self?.dismiss(animated: true, completion: nil)
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewDisapear?()
    }
}
