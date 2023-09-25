//
//  PlayerListViewModel.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import Foundation

enum PlayerListViewState {
    case empty
    case search(String?)
    case loadingPage(Int)
    case error(String)
    case list([Player])
    
    var isFetching: Bool {
        switch self {
        case .search, .loadingPage:
            return true
        default:
            return false
        }
    }
}

class PlayerListViewModel {
    private let playersProvider: PlayersProvider
    private var onPlayerSelected: ((Player) -> ())
    
    private let playersProviderPageSize = 25
    
    private var model = PlayerListModel()
    
    private var searchTask: Task<Void, Never>?
    private var loadingTask: Task<Void, Never>?
    
    private(set) var state: PlayerListViewState = .empty {
        didSet {
            onViewStateUpdated?()
        }
    }
    
    var onViewStateUpdated: (() -> ())?
    
    init(playersProvider: PlayersProvider, onPlayerSelected: @escaping (Player) -> ()) {
        self.playersProvider = playersProvider
        self.onPlayerSelected = onPlayerSelected
    }
    
    func searchPlayers(query: String?) {
        //TODO: add logic to "aggregate" the input events so that we don't overload the server
        
        guard areQueriesDifferent(q1: query, q2: model.searchPlayersQuery) else { return }
        
        loadingTask?.cancel()
        loadingTask = nil
        
        searchTask?.cancel()
        
        state = .search(query)
        
        searchTask = fetchPlayersTask(page: 1, query: query)
    }
    
    func loadMorePlayers() {
        guard !state.isFetching else { return }
        
        let nextPage = model.playersProviderPage + 1
        
        state = .loadingPage(nextPage)
        
        loadingTask = fetchPlayersTask(page: nextPage, query: model.searchPlayersQuery)
    }
    
    func selectPlayer(playerId: PlayerID) {
        guard let player = model.players.first(where: { $0.id == playerId }) else {
            return
        }
        
        onPlayerSelected(player)
    }
    
    private func fetchPlayersTask(page: Int, query: String?) -> Task<Void, Never> {
        return Task { @MainActor in
            do {
                let fetchedPlayers = try await playersProvider.fetchPlayers(
                    page: page,
                    pageSize: playersProviderPageSize,
                    name: query)
                
                guard !Task.isCancelled else { return }
                
                switch state {
                case .search(let query):
                    model.searchPlayersQuery = query
                    model.playersProviderPage = 1
                    model.players = fetchedPlayers
                case .error(let message):
                    state = .error(message)
                case .loadingPage(let page):
                    model.playersProviderPage = page
                    model.players.append(contentsOf: fetchedPlayers)
                default:
                    break; //.list() should never happen
                }
                
                if model.players.count > 0 {
                    state = .list(model.players)
                }
                else {
                    state = .empty
                }
            }
            catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    private func areQueriesDifferent(q1: String?, q2: String?) -> Bool {
        if q1 == "" || q1 == nil {
            if q2 == "" || q2 == nil {
                return false
            }
        }
        
        return q1 != q2
    }
}
