//
//  PlayerInfoView.swift
//  PlayersBrowser
//
//  Created by mukov on 18.09.23.
//

import UIKit

//TODO: change to either TableView or CollectionView

class PlayerInfoView: UIView {
    struct PlayerInfoViewData {
        let items: [Item]
        
        enum Item {
            case text(TextItem)
            case button(ButtonItem)
        }
        
        struct ButtonItem {
            let title: String
            let action: () -> ()
        }
        
        struct TextItem {
            let caption: String
            let title: String
        }
    }
    
    private let viewData: PlayerInfoViewData
    
    init(viewData: PlayerInfoViewData) {
        self.viewData = viewData
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        
    }
    
    private func setupView() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        
        var viewConstraints: [NSLayoutConstraint] = []
        
        for item in viewData.items {
            let itemView: UIView
            
            switch item {
            case .button(let buttonData):
                itemView = createItemView(buttonData: buttonData)
            case .text(let textData):
                itemView = createItemView(textData: textData)
            }
            
            stack.addArrangedSubview(itemView)
            viewConstraints.append(itemView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor))
        }
        
        addSubview(stack)
        
        viewConstraints.append(contentsOf: [
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    private func createItemView(textData: PlayerInfoViewData.TextItem) -> UIView {
        let captionLabel = UILabel()
        captionLabel.text = textData.caption
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = textData.title
        
        let stack = UIStackView(arrangedSubviews: [captionLabel, titleLabel])
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .equalCentering
        stack.spacing = 8
        
        return stack
    }
    
    private func createItemView(buttonData: PlayerInfoViewData.ButtonItem) -> UIView {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(buttonData.title, for: .normal)
        button.setTitle(buttonData.title, for: .highlighted)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.handleControlEvent(event: .touchUpInside) {
            buttonData.action()
        }
        
        return button
    }
}
