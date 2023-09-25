//
//  StatsProvider.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import Foundation

//TODO: add cache/storage dependency

protocol StatsProvider {
    func fetchPlayerStats(id playerId: PlayerID, year: Int) async throws -> PlayerStats?
}
