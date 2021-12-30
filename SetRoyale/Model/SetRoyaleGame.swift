//
//  SetRoyaleGame.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 30/12/21.
//

import Foundation
import UIKit

struct SetRoyaleGame{
    
    // MARK: Model
    struct Card: Identifiable,Equatable{
        let id: String
        let shape: CardShape
        let color: CardColor
        let shade: CardShade
        let number: CardNumber
        var isSelected: Bool = false
        var isMatched: Bool = false
        var isDealt: Bool = false
        
    }
    
    
    // MARK: - Properties
    private static let deckSize = 81
    
    
    
    private(set) var deck: [Card]
    var dealedCards: [Card]{
        return self.deck.filter({$0.isDealt == true})
    }
    
    var selectedCards: [Card]{
        
        return self.deck.filter({$0.isSelected == true})
        
    }
    
    var matchedCards: [Card]{
        
        return self.deck.filter({$0.isMatched == true})
        
    }
    
    private(set) var score: Int = 0
    
    var isDeckEmpty: Bool{
        return deck.isEmpty
    }
    
    
    // MARK: - Initializer
    init(){
        self.deck = SetRoyaleGame.createDeck()
        
        for index in 0...11{
            self.deck[index].isDealt = true
        }
        
    }
    
    
    // MARK: - Methods
    
    static func createDeck() -> [Card]{
        var deck:[Card] = []
        
        for number in CardNumber.allCases{
            for shape in CardShape.allCases{
                for color in CardColor.allCases{
                    for shade in CardShade.allCases{
                        deck.append(Card(id: UUID().uuidString, shape: shape, color: color, shade: shade, number: number))
                    }
                    
                }
            }
        }
        
        deck.shuffle()
        
        
        print(deck.prefix(20))
        
        return deck
    }
    
    
    mutating func chooseCard(_ card: Card){
        guard let chosenCardIndex = self.deck.firstIndex(where: { $0 == card}) else{return}
        
        
        if self.selectedCards.count == 3 , self.deck[chosenCardIndex].isMatched{
            return
        }
        
        
        
        self.deck[chosenCardIndex].isSelected.toggle()
        
        
        if self.selectedCards.count == 3{
            self.checkSelectedCards()
        }
        
        
    }
    
    
    mutating func checkSelectedCards(){
        guard let firstCard = self.selectedCards.first, let lastCard = self.selectedCards.last else{return}
        
        guard (firstCard.shape == self.selectedCards[1].shape && firstCard.shape == lastCard.shape) || (firstCard.shape != self.selectedCards[1].shape && firstCard.shape != lastCard.shape) else{return}
        
        guard (firstCard.color == self.selectedCards[1].color && firstCard.color == lastCard.color) || (firstCard.color != self.selectedCards[1].color && firstCard.color != lastCard.color) else{
            
            return
        }
        
        guard (firstCard.number == self.selectedCards[1].number && firstCard.number == lastCard.number) || (firstCard.number != self.selectedCards[1].number && firstCard.number != lastCard.number) else{
            
            return
        }
        
        guard (firstCard.shade == self.selectedCards[1].shade && firstCard.shade == lastCard.shade) || (firstCard.shade != self.selectedCards[1].shade && firstCard.shade != lastCard.shade) else{
            
            return
        }
        
        // Match found
        
        // set is matched to true
        for card in self.selectedCards{
            guard let index = self.deck.firstIndex(of: card) else{break}
            self.deck[index].isMatched = true
        }
        
        
        
        self.updateScore(+3)
        
    }
    
    
    
    
    mutating func dealCards(){
        
        let actualDealCardsIndex = self.dealedCards.count - 1
        //- self.matchedCards.count
        
        debugPrint(actualDealCardsIndex)
        
        for index in 0..<actualDealCardsIndex+3{
            self.deck[index].isDealt = true
            if self.deck[index].isMatched {
                self.deck[index].isSelected = false
                self.deck[index].isDealt = false
            }
        }

        
        
        
    }
    
    
    mutating func updateScore(_ newScore: Int){
        self.score = self.score + newScore
    }
    
    
}

// MARK: - Enums

enum CardNumber: Int , CaseIterable{
    case one = 1
    case two = 2
    case three = 3
    
}



enum CardShape: CaseIterable{
    
    case diamond
    case oval
    case squiggle
    
}

enum CardColor: String, CaseIterable{
    case red = "#FF0000"
    case purple = "#800080"
    case green = "#008000"
}


enum CardShade: CaseIterable{
    case solid
    case stripe
    case outlined
}
