//
//  ArtistTableViewCell.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 22/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

class ArtistTableViewCell: UITableViewCell {

    static var identifier = "artistCellIdentifier"
    
    var delegate: ((ArtistViewModel) -> ())?
    var artistViewModel: ArtistViewModel?
    
    var artist: ArtistViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var artistImageview = UIImageView()
    
    private lazy var artisNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 16)
        
        return l
    }()
    
    
    @objc public lazy var accessorySpinner: SpinnerView = {
        let v = SpinnerView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(artistImageview)
        contentView.addSubview(artisNameLabel)
        contentView.addSubview(accessorySpinner)
        
        contentView.backgroundColor = .clear
        
        artistImageview.translatesAutoresizingMaskIntoConstraints = false
        artistImageview.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        artistImageview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        artistImageview.heightAnchor.constraint(equalToConstant: 70).isActive = true
        artistImageview.widthAnchor.constraint(equalToConstant: 70).isActive = true
        artistImageview.layer.cornerRadius = 35
        artistImageview.clipsToBounds = true
        artistImageview.contentMode = .scaleAspectFill
        
        artisNameLabel.leftAnchor.constraint(equalTo: artistImageview.rightAnchor, constant: 20).isActive = true
        artisNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        artisNameLabel.centerYAnchor.constraint(equalTo: artistImageview.centerYAnchor).isActive = true

        accessorySpinner.centerXAnchor.constraint(equalTo: artistImageview.centerXAnchor).isActive = true
        accessorySpinner.centerYAnchor.constraint(equalTo: artistImageview.centerYAnchor).isActive = true
        accessorySpinner.heightAnchor.constraint(equalToConstant: 24).isActive = true
        accessorySpinner.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellSelected(_:))))
    }
    
    @objc private func cellSelected(_ sender: Any) {
        guard let artist = self.artist else { return }
        self.delegate?(artist)
    }
    
    override func prepareForReuse() {
        self.imageView?.image = nil
        self.imageView?.isHidden = true
    }
    
    private func updateUI() {
        artisNameLabel.text = artist?.name
        accessorySpinner.state = .spinning
        self.imageView?.image = nil
        
        artist?.imageCompletion = { [weak self] image in
            DispatchQueue.main.async {
                self?.artistImageview.image = image
                self?.accessorySpinner.state = .idle
            }
        }

        artisNameLabel.isHidden = false
        artistImageview.isHidden = false

    }
    
}
