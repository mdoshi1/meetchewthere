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
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        let controller: UIViewController
        if presentationStyle == .compact {
            controller = buildFavoritesViewController()
        } else {
            controller = buildVotingViewController(conversation.selectedMessage!)
        }
        presentViewController(controller: controller)
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
    
    fileprivate func composeMessage(_ chosenRestaurants: [Int], session: MSSession? = nil) -> MSMessage {
        let message = MSMessage(session: session ?? MSSession())
        let layout = MSMessageTemplateLayout()
        var components = URLComponents()
        var queryItems: [URLQueryItem] = []
        
        var index = 0
        for restaurant in chosenRestaurants {
            let item = URLQueryItem(name: "Restaurant" + String(index), value: String(restaurant))
            queryItems.append(item)
            index += 1
        }
        
        components.queryItems = queryItems
        
        layout.caption = "Rank your restaurant preferences!"
        message.url = components.url!
        message.layout = layout
        
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
