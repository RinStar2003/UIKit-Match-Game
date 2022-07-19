//
//  CardCollectionViewCell.swift
//  The Match Game
//
//  Created by мас on 07.07.2022.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var FrontImageView: UIImageView!
    
    @IBOutlet weak var BackImageView: UIImageView!
    
    var card: Card?
    
    func configureCell(card: Card) {
        
        // Keep track of the card this cell represents
        self.card = card
        
        // Set the front Image View
        FrontImageView.image = UIImage(named: card.imageName)
        
        // Reset the state of the cell by checking the flip status of the card and showing the front or the back imageview accrodingly
        
        if card.isMatched == true {
            
            BackImageView.alpha = 0
            FrontImageView.alpha = 0
            return
        } else {
            
            BackImageView.alpha = 1
            FrontImageView.alpha = 1
            
        }
        
        if card.isFliped == true {
            
            // Show front image view
            flipUp(speed: 0)
            
        } else {
            
            // Show the back image view
            flipDown(speed: 0, delay: 0)
            
        }
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        
        // Flip up animation
        UIView.transition(from: BackImageView, to: FrontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        card?.isFliped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            // Flip down animation
            UIView.transition(from: self.FrontImageView, to: self.BackImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        card?.isFliped = false
        
    }
    
    func remove() {
        
        // Makes cards invisible
        BackImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.FrontImageView.alpha = 0
            
        }, completion: nil)
        
    }
}
