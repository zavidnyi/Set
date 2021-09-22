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
            newGame
            gameBody
            HStack {
                deck
                Spacer()
                discardPile
            }
        }
    }
    
    @Namespace private var dealingNamespace
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: ClassicSetGame.Card) { dealt.insert(card.id) }
    
    private func isDealt(_ card: ClassicSetGame.Card) -> Bool { dealt.contains(card.id) }
    
    private func dealAnimation(for card: ClassicSetGame.Card) -> Animation {
        var delay = 0.0
        if let index = gameManager.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (DealConstants.totalDealDuration / 81)
        }
        return Animation.easeInOut(duration: DealConstants.dealDuration).delay(delay)
    }
    
    var newGame: some View {
        Button {
            gameManager.newGame()
            dealt = []
        } label: {
            Text("NewGame").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).padding()
        }
    }
    
    var gameBody:  some View {
        AspectVGrid(items: gameManager.cards, aspectRatio: DealConstants.aspectRatio, content: { card in
            if isDealt(card) {
                CardView(color: ClassicSetGameView.colors[card[1]], inMatchingSet: gameManager.matchingSet.contains(card), matchCorrect: gameManager.cardsAreMatched, symbol: card[2], numberOfShapes: card[3], decor: card[4])
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        withAnimation {
                            gameManager.choose(card)
                        }
                    }
            }
        })
    }
    
    var deck: some View {
        ZStack {
            ForEach (gameManager.deck + gameManager.cards.filter { !isDealt($0) }) { card in
                RoundedRectangle(cornerRadius: DealConstants.pileRadius)
                    .fill(ClassicSetGameView.colors[card[1]])
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .padding(4)
            }
        }
        .frame(width: DealConstants.pileWidth, height: DealConstants.pileHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding()
        .onAppear{
            for card in gameManager.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
        .onTapGesture {
            withAnimation {
                gameManager.deal3Cards()
            }
            for card in gameManager.cards.filter({ !isDealt($0) }) {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var discardPile: some View {
        ZStack {
            ForEach (gameManager.discard) { card in
                CardView(color: ClassicSetGameView.colors[card[1]], inMatchingSet: gameManager.matchingSet.contains(card), matchCorrect: gameManager.cardsAreMatched, symbol: card[2], numberOfShapes: card[3], decor: card[4])
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .aspectRatio(2/3, contentMode: .fit)

            }
        }
        .frame(width: DealConstants.pileWidth, height: DealConstants.pileHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    private struct DealConstants {
        static let aspectRatio: CGFloat = 2/3
        static let pileHeight: CGFloat = 110
        static let pileWidth = pileHeight * aspectRatio
        static let pileRadius: CGFloat = 25
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 3
    }
}



struct CardView: View {
    let color: Color
    var inMatchingSet: Bool
    var matchCorrect: Bool?
    let symbol: Int
    let numberOfShapes: Int
    let decor: Int
    
    @State private var isReversed = false
    var body: some View {
        ZStack(alignment: .center){
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
        .shadow(color: inMatchingSet  && matchCorrect != nil && matchCorrect! ? .green : .clear, radius: 3)
        .animation(.easeInOut)
        .shakeEffect(withForce: inMatchingSet  && matchCorrect != nil && !matchCorrect! ? 1 : 0)
        .padding(4)
    }
}






























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicSetGame()
        ClassicSetGameView(gameManager: game)
    }
}
