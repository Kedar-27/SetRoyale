//
//  SetRoyaleApp.swift
//  SetRoyale
//
//  Created by Kedar Sukerkar on 30/12/21.
//

import SwiftUI

@main
struct SetRoyaleApp: App {
    var body: some Scene {
        
        let viewModel = SetRoyaleViewModel()
        
        WindowGroup {
            SetRoyaleGameView(viewModel: viewModel)
        }
    }
}
