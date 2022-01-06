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
    @State var tempDiscardedCards = Set<String>()
    @State var isUnDealingAnimationComplete = true
    
    
    @Namespace private var dealingNamespace
        
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
                        self.isUnDealingAnimationComplete = true
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
        
        let cards =  isUnDealingAnimationComplete ? viewModel.cards: self.viewModel.deck.filter({$0.isMatched || $0.isDealt}).filter({ !self.isDiscarded($0) })
    
        return  AspectVGrid(items: cards, aspectRatio: CardConstants.aspectRatio) { card in
            if  self.isUndealt(card) || self.isDiscardedBeforeAnimation(card) {
                Color.clear
            }
            else {
                CardView(viewModel: self.viewModel, card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .zIndex(zIndex(of: card))
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                            viewModel.choose(card)
                        }
                    }
                    .onChange(of: self.viewModel.matchedCards) { newValue in
                        
                        self.isUnDealingAnimationComplete = false
                    }
                    
                    .onChange(of: self.viewModel.unDealtMatchedCards) { newValue in
                        
                        self.unDealWithAnimation()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                            self.discardedCards = self.tempDiscardedCards
                            self.isUnDealingAnimationComplete = true
                            self.dealWithAnimation()
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
            self.dealWithAnimation()
        }

    }
    
    var discardedPile: some View{
        
        ZStack {
            ForEach(viewModel.deck.filter(isDiscardedBeforeAnimation)) { card in
                CardView(viewModel: self.viewModel, card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition
                                    .asymmetric(insertion: .identity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        

    }


 
    // MARK: - Methods
    private func dealWithAnimation(){
        for card in self.viewModel.cards{
            withAnimation(dealAnimation(for: card)) {
                self.deal(card)
            }
        }
        
    }
    
    private func unDealWithAnimation(){
        for card in self.viewModel.matchedCards{
            withAnimation(unDealAnimation(for: card)) {
                self.unDealBeforeAnimation(card)
            }
            
        }
        
    }
    
    private func deal(_ card: SetRoyaleGame.Card){
        self.dealtCards.insert(card.id)
    }
    
    private func isUndealt(_ card: SetRoyaleGame.Card) -> Bool{
        !self.dealtCards.contains(card.id)
    }
    
    
    private func unDeal(_ card: SetRoyaleGame.Card){
        self.discardedCards.insert(card.id)
    }

    
    
    private func isDiscarded(_ card: SetRoyaleGame.Card) -> Bool{
        self.discardedCards.contains(card.id) && self.viewModel.unDealtMatchedCards.contains(card)
    }

    private func unDealBeforeAnimation(_ card: SetRoyaleGame.Card){
        self.tempDiscardedCards.insert(card.id)
    }

    
    
    private func isDiscardedBeforeAnimation(_ card: SetRoyaleGame.Card) -> Bool{
        self.tempDiscardedCards.contains(card.id) && self.viewModel.unDealtMatchedCards.contains(card)
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
    
    private func unDealAnimation(for card: SetRoyaleGame.Card) -> Animation {
        var delay = 0.0
        if var index = viewModel.matchedCards.firstIndex(where: { $0.id == card.id }) {
            index  = (index % 3) + 1
            delay = Double(index) * ( CardConstants.totalDealDuration / 3)
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
