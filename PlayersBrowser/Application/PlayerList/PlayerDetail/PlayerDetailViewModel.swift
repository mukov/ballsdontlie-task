//
//  PlayerDetailViewModel.swift
//  PlayersBrowser
//
//  Created by mukov on 18.09.23.
//

import Foundation

class PlayerDetailViewModel {
    private let model: PlayerDetailModel
    
    var onShowPlayerStats: ((PlayerID) -> ())?
    
    init(player: Player) {
        model = PlayerDetailModel(player: player)
    }
    
    func showPlayerStats() {
        onShowPlayerStats?(model.player.id)
    }
    
    var playerNameCaption: String { return "Name:" }
    var playerName: String {
        return "\(model.player.firstName) \(model.player.lastName)"
    }
    
    var playerPositionCaption: String { return "Position:" }
    var playerPosition: String {
        return model.player.position
    }
    
    var playerHeightCaption: String { return "Height:" }
    var playerHeight: String? {
        guard let feet = model.player.heightFeet, let inches = model.player.heightInches else {
            return nil
        }
        
        return "\(feet)'\(inches)\""
    }
    
    var playerWeightCaption: String { return "Width:" }
    var playerWeight: String? {
        guard let weight = model.player.weightPounds else {
            return nil
        }
        
        return "\(weight)"
    }
    
    var teamNameCaption: String { return "Team:" }
    var teamName: String {
        return "\(model.player.team.city) \(model.player.team.name)"
    }
    
    var teamDivisionCaption: String { return "Division:" }
    var teamDivision: String { return model.player.team.division }
    
    var statsButtonTitle: String { return "Show Stats" }
}
