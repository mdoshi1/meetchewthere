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
        let controller = buildFavoritesViewController()
        presentViewController(controller: controller)
    }
    
    // MARK: - View Controller Presentation
    
    private func buildFavoritesViewController() -> UIViewController {
        let controller = FavoritesViewController()
        return controller
    }

}

extension MessagesViewController {
    func presentViewController(controller: UIViewController) {
        
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
}
