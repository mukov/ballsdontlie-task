//
//  PlayerDetailViewController.swift
//  PlayersBrowser
//
//  Created by mukov on 18.09.23.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    private let viewModel: PlayerDetailViewModel
    
    init(viewModel: PlayerDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var playerDetailView: PlayerInfoView = {
        var playerInfoViewDataItems: [PlayerInfoView.PlayerInfoViewData.Item] = []
        
        playerInfoViewDataItems.append(
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: viewModel.playerNameCaption, title: viewModel.playerName)))
        
        playerInfoViewDataItems.append(
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: viewModel.playerPositionCaption, title: viewModel.playerPosition)))
        
        if let playerHeight = viewModel.playerHeight {
            playerInfoViewDataItems.append(
                .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                    caption: viewModel.playerHeightCaption, title: playerHeight)))
        }
        
        if let playerWeight = viewModel.playerWeight {
            playerInfoViewDataItems.append(
                .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                    caption: viewModel.playerWeightCaption, title: playerWeight)))
        }
        playerInfoViewDataItems.append(
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: viewModel.teamNameCaption, title: viewModel.teamName)))
        
        playerInfoViewDataItems.append(
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: viewModel.teamDivisionCaption, title: viewModel.teamDivision)))
        
        playerInfoViewDataItems.append(
            .button(PlayerInfoView.PlayerInfoViewData.ButtonItem(
                title: viewModel.statsButtonTitle, action: { [weak self] in
                    self?.viewModel.showPlayerStats()
                })))
        
        let view = PlayerInfoView(viewData: PlayerInfoView.PlayerInfoViewData(items: playerInfoViewDataItems))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(playerDetailView)
        
        view.addConstraints([
            playerDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            playerDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 24),
            playerDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            playerDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 24)
        ])
    }
}
