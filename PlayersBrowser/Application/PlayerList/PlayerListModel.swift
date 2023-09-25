//
//  PlayerListModel.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import Foundation

import Foundation

struct PlayerListModel {
    var players: [Player] = []
    
    var searchPlayersQuery: String?
    var playersProviderPage: Int = 0
}
