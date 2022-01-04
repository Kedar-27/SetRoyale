//
//  SetRoyaleGameView.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 30/12/21.
//

import SwiftUI

struct SetRoyaleGameView: View {
    
    // MARK: - Properties
    
    
    @ObservedObject var viewModel: SetRoyaleViewModel
    
    
    @State var dealtCards =  Set<String>()
    @State var discardedCards = Set<String>()
    
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    
    var body: some View {
        NavigationView{
            
            ZStack(alignment: .bottom){
                VStack(alignment: .center) {
                    cardBody
                    Spacer(minLength: 5)
                }
                
                HStack{
                    dealCardPile
                    Spacer()
                    discardedPile
                }
                
            }
            .font(.largeTitle)
            .padding(.all, 15.0)
            .navigationBarTitle("SetRoyale", displayMode: .inline)
            
            .navigationViewStyle(.stack)
            
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Text("Score: \(self.viewModel.score)")
                    
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        self.viewModel.createNewGame()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    
                }
                
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Views
    
    var cardBody: some View{
        
        AspectVGrid(items: viewModel.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if  self.isUndealt(card) || (card.isMatched){
                //Rectangle().opacity(0) // Can be replaced with Color.clear
                Color.clear
            }
            else {
                CardView(viewModel: self.viewModel, card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .zIndex(zIndex(of: card))
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1)) {
                            viewModel.choose(card)
                        }
                        
                        
                    }
            }
        }

        
    }
    
    var dealCardPile: some View{
        
        ZStack {
            ForEach(viewModel.deck.filter(isUndealt)) { card in
                CardView(viewModel: self.viewModel, card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition
                                    .asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            // "deal" cards
            
            self.viewModel.dealMoreCards()
            
            for card in self.viewModel.cards{

                withAnimation(dealAnimation(for: card)) {
                    self.deal(card)
                }
            }
            
            
            
            
        }

    }
    
    var discardedPile: some View{
        
        ZStack {
            ForEach(viewModel.deck.filter(isDiscarded)) { card in
                CardView(viewModel: self.viewModel, card: card)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                    .transition(AnyTransition
                                    .asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)



    }

    

    
//    var dealCardsButton: some View{
//        Button() {
//            self.viewModel.dealMoreCards()
//        } label: {
//            Text("Deal 3 cards")
//                .padding()
//        }
//        .disabled(self.viewModel.isDeckEmpty)
//        .foregroundColor(.white)
//        .background(RoundedRectangle(cornerRadius: 10   , style: .continuous).foregroundColor(.cyan))
//        .font(.headline)
//        .frame(width: 140, height: 50)
//
//    }
    

 
    // MARK: - Methods
    
    private func deal(_ card: SetRoyaleGame.Card){
        self.dealtCards.insert(card.id)
    }
    
    private func isUndealt(_ card: SetRoyaleGame.Card) -> Bool{
        !self.dealtCards.contains(card.id)
    }
    
    private func isDiscarded(_ card: SetRoyaleGame.Card) -> Bool{
        return card.isMatched
    }

    
    
    private func dealAnimation(for card: SetRoyaleGame.Card) -> Animation {
        var delay = 0.0
        if var index = viewModel.cards.firstIndex(where: { $0.id == card.id }) {
            if index > 11 {
                index  = (index % 3) + 1
                
            }
            
            
            delay = Double(index) * ( CardConstants.totalDealDuration / Double(viewModel.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: SetRoyaleGame.Card) -> Double {
        -Double(viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }

    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }

    
    
}















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetRoyaleViewModel()
        SetRoyaleGameView(viewModel: viewModel)
    }
}
