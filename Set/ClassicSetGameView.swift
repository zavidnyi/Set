//
//  ClassicSetGameView.swift
//  Set
//
//  Created by Ilya Zavidny on 21.09.2021.
//

import SwiftUI

struct ClassicSetGameView: View {
    static let colors: [Color] = [.purple, .gray, .orange]
    
    @ObservedObject var gameManager: ClassicSetGame
    var body: some View {
        VStack {
            Button {
                gameManager.newGame()
            } label: {
                Text("NewGame").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).padding()
            }
            AspectVGrid(items: gameManager.cards, aspectRatio: 2/3, content: { card in
                CardView(color: ClassicSetGameView.colors[card[1]], inMatchingSet: gameManager.matchingSet.contains(card), matchCorrect: gameManager.cardsAreMatched, symbol: card[2], numberOfShapes: card[3], decor: card[4])
                    .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            gameManager.choose(card)
                        }
            })
            Button {
                gameManager.deal3Cards()
            } label: {
                Text("Deal 3 more cards").font(.title).padding(.vertical)
            }
            .disabled(gameManager.deckIsEmpty)
        }
    }
}



struct CardView: View {
    let color: Color
    var inMatchingSet: Bool
    var matchCorrect: Bool?
    let symbol: Int
    let numberOfShapes: Int
    let decor: Int
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            shape.foregroundColor(.white)
            if inMatchingSet {
                if let isCor = matchCorrect {
                    if isCor {
                        shape.strokeBorder(lineWidth: 3).foregroundColor(.green)
                    } else {
                        shape.strokeBorder(lineWidth: 3).foregroundColor(.red)
                    }
                } else {
                    shape.strokeBorder(lineWidth: 6).foregroundColor(.blue)
                }
            } else {
                shape.strokeBorder(lineWidth: 3).foregroundColor(color)
            }
            VStack {
                ForEach(0..<numberOfShapes+1) { _ in
                    switch symbol {
                    case 0: ZStack {
                        Diamond().stroke()
                        switch decor {
                        case 0: Diamond().opacity(0.5)
                        case 1: Diamond().fill()
                        default: Diamond().stroke()
                        }
                    }
                    case 1: ZStack {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke()
                        switch decor {
                        case 0: RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).opacity(0.5)
                        case 1: RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).fill()
                        default: RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke()
                        }
                    }
                    default: ZStack {
                        Rectangle().stroke()
                        switch decor {
                        case 0: Rectangle().opacity(0.3)
                        case 1: Rectangle().fill()
                        default: Rectangle().stroke()
                        }
                    }
                    }
                }
                .aspectRatio(2/1, contentMode: .fit).padding(7).foregroundColor(color)
            }
        }
        .padding(4)
    }
}






























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(gameManager: game)
    }
}
