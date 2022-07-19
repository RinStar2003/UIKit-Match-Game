//
//  CardModel.swift
//  The Match Game
//
//  Created by мас on 07.07.2022.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an empty array to store number that we've generated
        var generatedNumbers = [Int]()
        
        // Declare an empty array to store all the card
        var generatedCards = [Card]()
        
        // Randomly generate 8 pairs of cards
        while generatedNumbers.count < 8  {
            
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                
                // Create two new card objects
                let card1 = Card()
                let card2 = Card()
                
                // Set their image names
                card1.imageName = "card\(randomNumber)"
                card2.imageName = "card\(randomNumber)"
                
                // Add them to the array
                /*generatedCards.append(card1)
                generatedCards.append(card2)*/
                
                generatedCards += [card1, card2]
                
                // Add this number to the list of generated numbers
                generatedNumbers.append(randomNumber)
                
                print(randomNumber)
                
            }
            
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards
    }
    
}
