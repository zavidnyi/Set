//
//  SetApp.swift
//  Set
//
//  Created by Ilya Zavidny on 21.09.2021.
//

import SwiftUI

@main
struct SetApp: App {
    let game = ClassicSetGame()
    var body: some Scene {
        WindowGroup {
            ClassicSetGameView(gameManager: game)
        }
    }
}
