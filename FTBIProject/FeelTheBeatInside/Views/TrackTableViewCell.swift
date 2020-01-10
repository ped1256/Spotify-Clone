//
//  TrackTableViewCell.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 24/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation

enum AccessoryType {
    case counter, volume
}

class TrackTableViewCell: UITableViewCell {
    static var identifier = "trackCellIdentifier"
    
    var trackCount = 0
    
    var trackViewModel: TrackViewModel? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 16)
        
        return l
    }()
    
    private lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 16)
        return l
    }()
    

    private lazy var volumeImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.image = UIImage(named: "green_play_icon")
        i.isHidden = true
        return i
    }()
    
    private lazy var trackNumberLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.white.withAlphaComponent(0.7)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        contentView.backgroundColor = #colorLiteral(red: 0.1782757183, green: 0.193023016, blue: 0.2144471764, alpha: 1)
        
        self.selectionStyle = .none
        contentView.addSubview(timeLabel)
        contentView.addSubview(trackNumberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(volumeImageView)
        
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        trackNumberLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        trackNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        nameLabel.leftAnchor.constraint(equalTo: trackNumberLabel.rightAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-90).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        volumeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        volumeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        volumeImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        volumeImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    override func prepareForReuse() {
        nameLabel.textColor = .white
        trackNumberLabel.textColor = .white
        timeLabel.textColor = .white
    }
    
    private func updateUI() {
        guard let track = trackViewModel else { return }
        nameLabel.text = track.name
        trackNumberLabel.text = "\(trackCount)"
        timeLabel.text = track.formattedMsTime
        
        if track.isPlaying {
            volumeImageView.isHidden = false
            nameLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
            trackNumberLabel.isHidden = true
            timeLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        } else {
            volumeImageView.isHidden = true
            trackNumberLabel.isHidden = false
        }
            
        
    }
    
}
