//
//  SetRoyaleViewModel.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 30/12/21.
//

import SwiftUI


class SetRoyaleViewModel: ObservableObject{
    
    
    // MARK: - Properties
    var cards: [SetRoyaleGame.Card]{
        self.model.dealedCards
    }
    
    var score: Int{
        self.model.score
    }

    var isDeckEmpty: Bool{
        self.model.isDeckEmpty
    }

    
    // Step 1: Add @Published to publish changes.
    @Published private var model: SetRoyaleGame = SetRoyaleViewModel.createSetRoyaleGame()

        
    
    // MARK: - Methods
    static func createSetRoyaleGame() -> SetRoyaleGame {
      return  SetRoyaleGame()
    }
    

    
    // MARK: - Helper Methods
    
    
//    @ViewBuilder func getShape(from card: SetRoyaleGame.Card) -> some View{
//
//        let color = Color(hex: card.color.rawValue)
//
//        switch card.shape{
//
//
//        case .diamond:
//            DiamondView()
//                .if(card.shade == .solid) { view in
//                    view.foregroundColor(color)
//                }
//                .if(card.shade == .outlined) { view in
//                    view.border(color, width: 4)
//
//                }
//                .if(card.shade == .stripe) { view in
//                    view.foregroundColor(color.opacity(0.4))
//                }
//
//        case .oval:
//            Capsule()
//                .if(card.shade == .solid) { view in
//                    view.foregroundColor(color)
//                }
//                .if(card.shade == .outlined) { view in
//                    view.border(color, width: 4)
//
//                }
//                .if(card.shade == .stripe) { view in
//                    view.foregroundColor(color.opacity(0.4))
//                }
//        case .squiggle:
//            RoundedRectangle(cornerRadius: 10)
//                .if(card.shade == .solid) { view in
//                    view.foregroundColor(color)
//                }
//                .if(card.shade == .outlined) { view in
//                    view.border(color, width: 4)
//
//                }
//                .if(card.shade == .stripe) { view in
//                    view.foregroundColor(color.opacity(0.4))
//                }
//        }
//
//       // EmptyView()
//    }
    
    
    @ViewBuilder func getShape(from card: SetRoyaleGame.Card) -> some View{
        
        let color = Color(hex: card.color.rawValue)
        
        switch card.shape{
            
            
        case .diamond:
            Image(systemName: card.shade == .solid ? "suit.diamond.fill": card.shade == .outlined ? "suit.diamond" : "diamond.tophalf.filled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color)
                
            
        case .oval:
            Image(systemName: card.shade == .solid ? "oval.fill": card.shade == .outlined ? "oval" : "oval.tophalf.filled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color)
                

        case .squiggle:
            Image(systemName: card.shade == .solid ? "rectangle.fill": card.shade == .outlined ? "rectangle" : "rectangle.lefthalf.filled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(color)
            
        }
        
       // EmptyView()
    }

    
    // MARK: - Intent(s)
    func createNewGame(){
        self.model = SetRoyaleViewModel.createSetRoyaleGame()
    }
    
    /// Deals 3 more cards
    func dealMoreCards(){
        self.model.dealCards()
        
    }
    
    func choose(_ card: SetRoyaleGame.Card){
        self.model.chooseCard(card)
    }

}
