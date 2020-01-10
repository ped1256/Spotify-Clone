//
//  SearchArtistsButton.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 26/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

import Foundation
class SearchArtistsButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle("Procurar artistas", for: .normal)
        self.setTitleColor(#colorLiteral(red: 0.4650579159, green: 0.5035283684, blue: 0.5594163799, alpha: 1), for: .normal)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .highlighted)
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
