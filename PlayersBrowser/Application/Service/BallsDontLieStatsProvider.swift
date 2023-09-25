//
//  BallsDontLieStatsProvider.swift
//  PlayersBrowser
//
//  Created by mukov on 18.09.23.
//

import Foundation

class BallsDontLieStatsProvider: StatsProvider {
    private let apiUrl = "https://www.balldontlie.io/api/v1"
    
    func fetchPlayerStats(id playerId: PlayerID, year: Int) async throws -> PlayerStats? {
        //TODO: Debugging purposes only. Remove it later.
        sleep(1)
        
        guard var urlComponents = URLComponents(string: "\(apiUrl)/season_averages") else {
            throw PlayersProviderError.badUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(
                name: "player_ids[]",
                value: "\(playerId)"),
            URLQueryItem(
                name: "season",
                value: "\(year)")]

        guard let url = urlComponents.url else {
            throw PlayersProviderError.badUrl
        }

        print(url)
        let (data, _) = try await URLSession.shared.data(from: url)

        let jsonDecoder = JSONDecoder()
        let json = try jsonDecoder.decode(JSONResponse.self, from: data)
        
        var stats: PlayerStats?
        if let jsonStats = json.data.first {
            stats = PlayerStats(
                playerId: jsonStats.player_id,
                seasonYear: jsonStats.season,
                gamesPlayed: jsonStats.games_played,
                pointsAverage: jsonStats.pts,
                reboundsAverage: jsonStats.reb,
                assistsAverage: jsonStats.ast,
                stealsAverage: jsonStats.stl,
                blocksAverage: jsonStats.blk)
        }
        
        return stats
    }
}

fileprivate struct JSONResponse: Codable {
    let data: [JSONStats]
}

fileprivate struct JSONStats: Codable {
    let games_played: Int
    let player_id: Int
    let season: Int
    let pts: Float
    let reb: Float
    let ast: Float
    let stl: Float
    let blk: Float
}
