//
//  Player.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import Foundation

typealias PlayerID = Int

struct Player {
    let id: PlayerID
    let firstName: String
    let lastName: String
    let position: String
    let heightInches: Int?
    let heightFeet: Int?
    let weightPounds: Int?
    let team: Team
}

struct Team {
    let name: String
    let city: String
    let division: String
    
    enum Conference {
        case east(East)
        case west(West)
        
        enum East {
            case atlantic
            case central
            case southeast
        }
        
        enum West {
            case northwest
            case pacific
            case southwest
        }
    }
}
