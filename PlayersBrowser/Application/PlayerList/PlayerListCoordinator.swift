//
//  PlayerListCoordinator.swift
//  PlayersBrowser
//
//  Created by mukov on 19.09.23.
//

import UIKit

class PlayerListCoordinator {
    private let navigationController: UINavigationController
    
    private let playersProvider = BallsDontLiePlayersProvider()
    private let statsProvider = BallsDontLieStatsProvider()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private lazy var playerListViewController: PlayerListViewController = {
        let playerListViewModel = PlayerListViewModel(
            playersProvider: playersProvider,
            onPlayerSelected: { [weak self] player in
                self?.navigateToPlayerDetail(player: player)
            })
        
        return PlayerListViewController(viewModel: playerListViewModel)
    }()
    
    private func navigateToPlayerDetail(player: Player, animated: Bool = true) {
        let playerDetailViewModel = PlayerDetailViewModel(player: player)
        playerDetailViewModel.onShowPlayerStats = { [weak self] playerId in
            self?.navigateToPlayerStats(playerId: playerId)
        }
        
        let playerDetail = PlayerDetailViewController(viewModel: playerDetailViewModel)
        
        navigationController.pushViewController(playerDetail, animated: animated)
    }
    
    private func navigateToPlayerStats(playerId: PlayerID, animated: Bool = true) {
        let playerStatsViewModel = PlayerStatsViewModel(playerId: playerId, statsProvider: statsProvider)
        let playerStats = PlayerStatsViewController(viewModel: playerStatsViewModel)
        playerStats.modalPresentationStyle = .formSheet
        
        navigationController.topViewController?.present(playerStats, animated: true)
    }
    
    func start() {
        navigationController.setViewControllers([playerListViewController], animated: false)
    }
}
