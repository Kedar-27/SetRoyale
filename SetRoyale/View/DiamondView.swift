//
//  DiamondView.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 30/12/21.
//

import SwiftUI

struct DiamondView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let length = min(geometry.size.width, geometry.size.height)
                let width = length
                let height = length
                let middle = length * 0.5
                let offset = length * 0.1

                path.move(to: CGPoint(x: 0, y: middle))
                path.addQuadCurve(to: CGPoint(x: middle, y: 0),
                                  control: CGPoint(x: middle-offset, y: middle-offset))
                path.addQuadCurve(to: CGPoint(x: width, y: middle),
                                  control: CGPoint(x: middle+offset, y: middle-offset))
                path.addQuadCurve(to: CGPoint(x: middle, y: height),
                                  control: CGPoint(x: middle+offset, y: middle+offset))
                path.addQuadCurve(to: CGPoint(x: 0, y: middle),
                                  control: CGPoint(x: middle-offset, y: middle+offset))
            }
            //.fill(Color.red)
        }
    }
}


struct DiamondView_Previews: PreviewProvider {
    static var previews: some View {
        DiamondView()
    }
}
