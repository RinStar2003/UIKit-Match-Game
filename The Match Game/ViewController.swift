//
//  ViewController.swift
//  The Match Game
//
//  Created by мас on 06.07.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer: Timer?
    var milliseconds: Double = 40  * 1000
    
    var firstFlippedCardIndex: IndexPath?
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
        
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
    
        // Update the label
        let seconds: Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Time remaining: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // Check if the user has cleared all the pairs
            checkForGameEnd()
            
        }
            
    }
    
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return cardsArray.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card array
        let card = cardsArray[indexPath.row]
        
        // TODO: - Finish configuring the cell
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt IndexPath: IndexPath) {
        
        // Check if there's any time left. Don't let user interact if the time is 0
        
        if milliseconds <= 0 {
            
            return
            
        }
    
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: IndexPath) as? CardCollectionViewCell
     
        // Check the status of the card to determine how to flip it
        if cell?.card?.isFliped == false && cell?.card?.isMatched == false {
            
            cell?.flipUp()
            
            soundPlayer.playSound(effect: .flip)
            
            if firstFlippedCardIndex == nil {
                
                // This is first card flipped over
                firstFlippedCardIndex = IndexPath
                
            } else {
                
                // Second card that is flipped
                
                
                // Run the comparison logic
                
                checkForMatch(IndexPath)
                
            }
        }
        
    }
    
    // MARK: - Game logic methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represents CardOne and CardTwo
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell

        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match!
            soundPlayer.playSound(effect: .match)
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
        } else {
            
            // It's not a match
            soundPlayer.playSound(effect: .nomatch)
            
            // Flip them back over
            cardOneCell?.flipDown() 
            cardTwoCell?.flipDown()
            
        }
        
        // Reset the firstFlippedCard property
        firstFlippedCardIndex = nil
        
    }
    
    func checkForGameEnd() {
        
        // Check if there's any card left
        
        // Assume the user has won, loop through all the cards to see if all of them are matched
        
        var hasWon = true
        
        for card in cardsArray {
            
            if card.isMatched == false {
                
                // We found the card that is unmatched
                hasWon = false
                break
            }
        }
        if hasWon == true {
            
            // User has won, show alert
            showAlert(title: "Congratulations!", message: "You've won the game!")
            
            
        } else {
            
            // User hasn't won yet, check if there's time left
            if milliseconds <= 0 {
                
                showAlert(title: "Time's up!", message: "Better luck next time!")
            }
            
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


