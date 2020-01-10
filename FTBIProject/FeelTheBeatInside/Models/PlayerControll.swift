//
//  PlayerControll.swift
//  FeelTheBeatInside
//
//  Created by Pedro Emanuel on 26/03/19.
//  Copyright © 2019 Pedro Emanuel. All rights reserved.
//

enum PlayerStates {
    case pause, resume, play, next, previous
}

import Foundation

struct PlayerControl {
    let isPlaying: Bool
    let state: PlayerStates
    let trackURI: String
}
