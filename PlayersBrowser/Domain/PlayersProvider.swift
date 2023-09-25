//
//  PlayersProvider.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import Foundation

//TODO: add cache/storage dependency

protocol PlayersProvider {
    func fetchPlayers(page: Int, pageSize: Int, name: String?) async throws -> [Player]
}
