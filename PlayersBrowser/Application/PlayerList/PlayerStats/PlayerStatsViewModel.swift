//
//  PlayerStatsViewModel.swift
//  PlayersBrowser
//
//  Created by mukov on 18.09.23.
//

import Foundation

enum PlayerStatsViewState {
    case stats(PlayerStatsViewData)
    case loading
    case noData
    case error(String)
}

struct PlayerStatsViewData {
    let seasonYearCaption: String
    let seasonYear: String
    let gamesPlayedCaption: String
    let gamesPlayed: String
    
    let pointsAverageCaption: String
    let pointsAverage: String
    let reboundsAverageCaption: String
    let reboundsAverage: String
    let assistsAverageCaption: String
    let assistsAverage: String
    let stealsAverageCaption: String
    let stealsAverage: String
    let blocksAverageCaption: String
    let blocksAverage: String
    
    init(stats: PlayerStats) {
        seasonYearCaption = "Season Year:"
        seasonYear = "\(stats.seasonYear)"
        gamesPlayedCaption = "Games:"
        gamesPlayed = "\(stats.gamesPlayed)"
        pointsAverageCaption = "Points:"
        pointsAverage = "\(stats.pointsAverage)"
        reboundsAverageCaption = "Rebounds:"
        reboundsAverage = "\(stats.reboundsAverage)"
        assistsAverageCaption = "Assists:"
        assistsAverage = "\(stats.assistsAverage)"
        stealsAverageCaption = "Steals:"
        stealsAverage = "\(stats.stealsAverage)"
        blocksAverageCaption = "Blocks:"
        blocksAverage = "\(stats.blocksAverage)"
    }
}

class PlayerStatsViewModel {
    private let statsProvider: StatsProvider
    
    private var playerStats: PlayerStats?
    
    private(set) var state: PlayerStatsViewState = .loading {
        didSet {
            onViewStateUpdated?()
        }
    }
    
    var onViewStateUpdated: (() -> ())?
    
    init(playerId: PlayerID, statsProvider: StatsProvider) {
        self.statsProvider = statsProvider
        
        state = .loading
        
        Task { @MainActor in
            do {
                if let stats = try await statsProvider.fetchPlayerStats(id: playerId, year: 2018) { //TODO: year selection in the UI should be implmented
                    playerStats = playerStats
                    state = .stats(PlayerStatsViewData(stats: stats))
                }
                else {
                    state = .noData
                }
            }
            catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    var noDataLabel: String { return "Player hasn't played the selected season"}
}
