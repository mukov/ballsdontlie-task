//
//  PlayerListViewController.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import UIKit

class PlayerListViewController: UIViewController {
    private let viewModel: PlayerListViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: PlayerListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private let playerListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PlayerListCell.self, forCellReuseIdentifier: PlayerListCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        
        return tableView
    }()
    
    private lazy var playerListTableViewDataSource: UITableViewDiffableDataSource<Int, PlayerListCell.PlayerData> = {
        UITableViewDiffableDataSource(tableView: playerListTableView) { tableView, indexPath, cellData in
            let cell: PlayerListCell = tableView.dequeueReusableCell(withIdentifier: PlayerListCell.reuseIdentifier, for: indexPath) as! PlayerListCell
            
            cell.data = PlayerListCell.PlayerData(
                playerId: cellData.playerId,
                playerName: cellData.playerName)
            
            return cell
        }
    }()
    
    private lazy var playerListLoadingFooterView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        view.backgroundColor = .clear
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Search players ..."
        
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerListTableView.dataSource = playerListTableViewDataSource
        playerListTableView.delegate = self
        
        navigationItem.searchController = searchController
        
        setupUI()
        
        viewModel.onViewStateUpdated = { [weak self] in
            guard let self = self else { return }
            
            switch viewModel.state {
            case .list(let players):
                playerListTableView.tableFooterView = nil
                
                let playerDatas = players.compactMap {
                    PlayerListCell.PlayerData(player: $0)
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<Int, PlayerListCell.PlayerData>()
                snapshot.appendSections([0])
                snapshot.appendItems(playerDatas)
                
                playerListTableViewDataSource.apply(snapshot, animatingDifferences: false)
            case .loadingPage:
                playerListTableView.tableFooterView = playerListLoadingFooterView
            case .search:
                let snapshot = NSDiffableDataSourceSnapshot<Int, PlayerListCell.PlayerData>()
                playerListTableViewDataSource.apply(snapshot, animatingDifferences: false)
                
                playerListTableView.tableFooterView = playerListLoadingFooterView
            default:
                playerListTableView.tableFooterView = nil
                
                //TODO: handle .empty and .error states
                print("====> .empty or error state")
            }
        }
        
        viewModel.loadMorePlayers()
    }
    
    private func setupUI() {
        view.addSubview(playerListTableView)
        
        let tableViewConstraints = [
            playerListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            playerListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        
        view.addConstraints(tableViewConstraints)
    }
}

extension PlayerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        
        viewModel.searchPlayers(query: text)
    }
}

extension PlayerListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > scrollView.bounds.size.height,
           scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height) {
            viewModel.loadMorePlayers()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let player = playerListTableViewDataSource.itemIdentifier(for: indexPath) {
            viewModel.selectPlayer(playerId: player.playerId)
        }
    }
}

fileprivate class PlayerListCell: UITableViewCell {
    static let reuseIdentifier = "PlayerListTableViewCellReuseIdentifier"
    
    var data: PlayerData? {
        didSet {
            playerNameLabel.text = data?.playerName
        }
    }
    
    private lazy var playerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(playerNameLabel)
        let constraints = [
            playerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            playerNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playerNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            playerNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)]
        
        contentView.addConstraints(constraints)
    }
    
    struct PlayerData: Hashable {
        let playerId: PlayerID
        let playerName: String
        
        init(playerId: PlayerID, playerName: String) {
            self.playerId = playerId
            self.playerName = playerName
        }
        
        init(player: Player) {
            playerId = player.id
            playerName = "\(player.firstName) \(player.lastName)"
        }
    }
}
