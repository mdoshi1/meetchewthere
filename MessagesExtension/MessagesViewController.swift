//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Michael-Anthony Doshi on 1/28/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: - Application State
    
    private enum AppState {
        case favorites
        case voting
    }
    
    private var currentState: AppState!
    
    // MARK: - MessagesViewController
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        let controller: UIViewController
        if presentationStyle == .compact {
            controller = buildFavoritesViewController()
            currentState = .favorites
        } else {
            controller = buildVotingViewController(conversation.selectedMessage!)
            currentState = .voting
        }
        presentViewController(controller: controller)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        if presentationStyle == .compact && currentState == .voting {
            presentViewController(controller: buildFavoritesViewController())
            currentState = .favorites
        } else if presentationStyle == .expanded {
            guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
            if let message = conversation.selectedMessage {
                presentViewController(controller: buildVotingViewController(message))
                currentState = .voting
            }
        }
    }
    
    // MARK: - View Controller Presentation
    
    private func buildFavoritesViewController() -> UIViewController {
        let controller = FavoritesViewController()
        controller.delegate = self
        return controller
    }
    
    private func buildVotingViewController(_ message: MSMessage) -> UIViewController {
        let controller = VotingViewController(message.url)
        return controller
    }
    
    // MARK: - Helper Methods
    
    private func presentViewController(controller: UIViewController) {
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    // MARK: - Message Composition
    
    fileprivate func composeMessage(_ chosenRestaurants: [Int], session: MSSession? = nil) -> MSMessage {
        let message = MSMessage(session: session ?? MSSession())
        let layout = MSMessageTemplateLayout()
        var components = URLComponents()
        var queryItems: [URLQueryItem] = []
        
        for restaurant in chosenRestaurants {
            let item = URLQueryItem(name: "Restaurant" + String(restaurant), value: String(restaurant))
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        layout.caption = "Rank your restaurant preferences!"
        layout.image = UIImage(named: "rest" + String(chosenRestaurants[0]) + ".png")
        message.url = components.url!
        message.layout = layout
        message.summaryText = "Thanks for your input!"
        
        return message
    }

}

extension MessagesViewController: FavoritesVCDelegate {
    func composeMessage(_ chosenRestaurants: [Int]) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        let message = composeMessage(chosenRestaurants, session: conversation.selectedMessage?.session)
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        requestPresentationStyle(.compact)
    }
}
