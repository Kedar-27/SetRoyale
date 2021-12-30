//
//  SetRoyaleGameView.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 30/12/21.
//

import SwiftUI

struct SetRoyaleGameView: View {
    
    @ObservedObject var viewModel: SetRoyaleViewModel
    
    
    var body: some View {
        NavigationView{
            
            VStack(alignment: .center) {
                AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
//                    if card.isMatched && !card.isFaceUp {
//                        Rectangle().opacity(0)
//                    }
                   // else {
                    CardView(viewModel: self.viewModel, card: card)
                            .padding(4)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                   // }
                }
                Spacer(minLength: 5)
                Button() {
                    self.viewModel.dealMoreCards()
                } label: {
                    Text("Deal 3 cards")
                        .padding()
                }
                .disabled(self.viewModel.isDeckEmpty)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 10   , style: .continuous).foregroundColor(.cyan))
                .font(.headline)
                .frame(width: 140, height: 50)
                
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

}















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetRoyaleViewModel()
        SetRoyaleGameView(viewModel: viewModel)
    }
}
