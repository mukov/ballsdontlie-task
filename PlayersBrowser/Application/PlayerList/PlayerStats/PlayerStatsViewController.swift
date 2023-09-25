//
//  PlayerStatsViewController.swift
//  PlayersBrowser
//
//  Created by mukov on 18.09.23.
//

import UIKit

class PlayerStatsViewController: UIViewController {
    private let viewModel: PlayerStatsViewModel
    
    init(viewModel: PlayerStatsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.onViewStateUpdated = { [weak self] in
            self?.setupUI()
        }
    }
    
    private var statsView: PlayerInfoView?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.style = .large
        
        return indicator
    }()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.noDataLabel
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loadingIndicator.isHidden = true
        view.addSubview(loadingIndicator)
        
        noDataLabel.isHidden = true
        view.addSubview(noDataLabel)
        
        view.addConstraints([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupUI()
    }
    
    private func setupUI() {
        noDataLabel.isHidden = true
        
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        
        statsView?.isHidden = true
        
        switch viewModel.state {
        case .stats(let statsData):
            setupStatsView(statsData: statsData)
            statsView?.isHidden = false
        case .loading:
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        case .noData:
            noDataLabel.isHidden = false
        case .error(let message):
            //TODO: handle error
            print("====> \(message)")
        }
    }
    
    private func setupStatsView(statsData: PlayerStatsViewData) {
        statsView?.removeFromSuperview()
        
        let newStatsView = PlayerInfoView(viewData: PlayerInfoView.PlayerInfoViewData(items: [
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: statsData.seasonYearCaption, title: statsData.seasonYear)),
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: statsData.gamesPlayedCaption, title: statsData.gamesPlayed)),
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: statsData.pointsAverageCaption, title: statsData.pointsAverage)),
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: statsData.reboundsAverageCaption, title: statsData.reboundsAverage)),
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: statsData.stealsAverageCaption, title: statsData.stealsAverage)),
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: statsData.assistsAverageCaption, title: statsData.assistsAverage)),
            .text(PlayerInfoView.PlayerInfoViewData.TextItem(
                caption: statsData.blocksAverageCaption, title: statsData.blocksAverage))
        ]))
        
        newStatsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newStatsView)
        
        view.addConstraints([
            newStatsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            newStatsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 24),
            newStatsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newStatsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 24)
        ])
        
        statsView = newStatsView
    }
}
