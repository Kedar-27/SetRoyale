//
//  CardView.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 30/12/21.
//

import SwiftUI

struct CardView: View {
    
    let viewModel: SetRoyaleViewModel
    let card: SetRoyaleGame.Card
    
    let color = Color.orange
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius:  DrawingConstants.cornerRadius)
        
        GeometryReader { geometry in
            ZStack {
                shape.fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: card.isMatched ? DrawingConstants.lineWidth : DrawingConstants.normalLineWidth, antialiased: true)
                
                    .foregroundColor(card.isMatched ? Color.teal : card.isSelected ? Color.yellow : Color(hex: card.color.rawValue))
                
                VStack {
                    
                    let cardShape = self.viewModel.getShape(from: card)
                    
                    ForEach(0..<card.number.rawValue, id: \.self) { _ in
                        
                        cardShape
                            .frame(minWidth: 0, maxWidth: 30, minHeight: 0, maxHeight: 30)
                            .padding(2)
                    }
                    
                    
                    
                }
            }
            .cardify(isFaceUp: card.isDealt || card.isMatched, color: color)
            
        }
        
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let normalLineWidth: CGFloat = 3
        static let lineWidth: CGFloat = 4
        static let fontScale: CGFloat = 0.70
        static let piePadding: CGFloat = 5
        static let pieOpacity = 0.4
    }
}
