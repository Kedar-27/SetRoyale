//
//  Cardify.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 05/01/22.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier{
    
    //var isFaceUp: Bool
    var color: Color
    
    
    var rotation: Double
    
    var animatableData: Double{
        get{
            rotation
        }
        set{
            rotation = newValue
        }
    }
    
    
    init(isFaceUp: Bool, color: Color){
        self.rotation = isFaceUp ? 0 : 180
        self.color = color
        
    }
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius:  DrawingConstants.cornerRadius)
        ZStack {
            
            if rotation < 90{
                
                shape.fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth, antialiased: true)
                    .foregroundColor(color)
                
            }else{
                shape
                    .fill()
                    .foregroundColor(color)
                
            }
            
            content
                .opacity(rotation < 90 ? 1 : 0)
            
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
        
        
        
        
        
        
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.70
        static let piePadding: CGFloat = 5
        static let pieOpacity = 0.4
    }
    
    
}
