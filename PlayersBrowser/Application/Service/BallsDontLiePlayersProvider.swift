//
//  BallsDontLiePlayersProvider.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import Foundation

enum PlayersProviderError: Error {
    case badUrl
    case invalidParameters
}

//TODO: Add cache for players
class BallsDontLiePlayersProvider: PlayersProvider {
    private let apiUrl = "https://www.balldontlie.io/api/v1"
    
    func fetchPlayers(page: Int, pageSize: Int, name: String? = nil) async throws -> [Player] {
        //TODO: Debugging purposes only. Remove it later.
        sleep(1)
        
        guard pageSize >= 0, pageSize <= 100 , page > 0 else {
            throw PlayersProviderError.invalidParameters
        }
        
        guard var urlComponents = URLComponents(string: "\(apiUrl)/players") else {
            throw PlayersProviderError.badUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(
                name: "page",
                value: String(page)),
            URLQueryItem(
                name: "per_page",
                value: String(pageSize))]
        
        if let name = name {
            urlComponents.queryItems?.append(URLQueryItem(
                name: "search",
                value: String(name)))
        }
        
        guard let url = urlComponents.url else {
            throw PlayersProviderError.badUrl
        }
        
        print(url)
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let jsonDecoder = JSONDecoder()
        let json = try jsonDecoder.decode(JSONResponse.self, from: data)
        
        let players = json.data.compactMap {
            return Player(
                id: $0.id,
                firstName: $0.first_name,
                lastName: $0.last_name,
                position: $0.position,
                heightInches: $0.height_inches,
                heightFeet: $0.height_feet,
                weightPounds: $0.weight_pounds,
                team: Team(
                    name: $0.team.name,
                    city: $0.team.city,
                    division: $0.team.division))
        }
        
        return players
    }
}

fileprivate struct JSONResponse: Codable {
    let data: [JSONPlayer]
    let meta: JSONMeta
}

fileprivate struct JSONPlayer: Codable {
    let id: Int
    let first_name: String
    let last_name: String
    let position: String
    let height_feet: Int?
    let height_inches: Int?
    let weight_pounds: Int?
    let team: JSONTeam
}

fileprivate struct JSONTeam: Codable {
    let id: Int
    let abbreviation: String
    let city: String
    let division: String
    let full_name: String
    let name: String
}

fileprivate struct JSONMeta: Codable {
    let total_pages: Int
    let current_page: Int
    let next_page: Int
    let per_page: Int
    let total_count: Int
}
