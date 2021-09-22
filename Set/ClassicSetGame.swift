//
//  ClassicSetGame.swift
//  Set
//
//  Created by Ilya Zavidny on 21.09.2021.
//

import SwiftUI

class ClassicSetGame: ObservableObject {
    typealias Card = SetGame.Card
    
    @Published private var model = SetGame()
    
    var cards: Array<Card> { Array(model.cards) }
    var matchingSet: Set<Card> { model.matchingSet }
    var cardsAreMatched: Bool? { model.areMatched }
    var deck: Array<Card> { Array(model.deck).reversed() }
    var discard: Array<Card> { model.discard }
    var deckIsEmpty: Bool { model.deck.count == 0 }
    
    // MARK: - Intent(s)
    
    func choose( _ card: Card) {
        model.choose(card)
    }
    
    func deal3Cards() {
        model.dealCards(3)
    }
    
    func newGame() {
        model = SetGame()
    }
}
