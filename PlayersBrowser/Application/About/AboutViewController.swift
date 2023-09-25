//
//  AboutViewController.swift
//  PlayersBrowser
//
//  Created by mukov on 17.09.23.
//

import UIKit

class AboutViewController: UIViewController {
    let viewModel: AboutViewModel
    
    init(viewModel: AboutViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.appName
        
        return label
    }()
    
    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.appVersion
        
        return label
    }()
    
    private lazy var containerView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [appNameLabel, appVersionLabel])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .equalCentering
        
        return vStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        
        let constraints = [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        
        view.addConstraints(constraints)
    }
}
