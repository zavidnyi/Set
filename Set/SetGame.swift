//
//  SetGame.swift
//  Set
//
//  Created by Ilya Zavidny on 21.09.2021.
//

import Foundation

struct SetGame {
    private(set) var deck: Set<Card>
    private(set) var cards: Set<Card>
    private(set) var matchingSet: Set<Card>
    private(set) var areMatched: Bool?
    
    init() {
        deck = []
        cards = []
        matchingSet = []
        areMatched = nil
        for quality1 in 0 ..< 3 {
            for quality2 in 0 ..< 3 {
                for quality3 in 0 ..< 3 {
                    for quality4 in 0 ..< 3 {
                        deck.insert(Card(quality1,quality2,quality3,quality4, id: deck.count))
                    }
                }
            }
        }
        for _ in 0...12 {
            let card = deck.randomElement()!
            cards.insert(card)
            deck.remove(card)
        }
    }
    
    private func doMakeSet(with card: Card) -> Bool {
        for quality in 1 ... 4 {
            if matchingSet.allSatisfy({ $0[quality] == card[quality] }) { return true }
        }
        return false
    }
    
    mutating func dealCards(_ amount: Int) {
        for _ in 0 ..< min(amount, deck.count) {
            let card = deck.randomElement()!
            cards.insert(card)
            deck.remove(card)
        }
    }
    
    mutating func choose(_ card: Card) {
        if matchingSet.count < 3 {
            if matchingSet.contains(card) {
                matchingSet.remove(card)
                return
            }
            matchingSet.insert(card)
            if matchingSet.count == 3 {
                areMatched = false
                if doMakeSet(with: card) {
                    areMatched = true
                }
            }
        } else {
            if areMatched! {
                matchingSet.forEach({ cards.remove($0)} )
                dealCards(3)
            }
            matchingSet.removeAll()
            areMatched = nil
            if cards.contains(card) {
                matchingSet.insert(card)
            }
        }
    }
    
    struct Card: Hashable, Identifiable {
        let firstQuality: Int
        let secondQuality: Int
        let thirdQuality: Int
        let forthQuality: Int
        let id: Int
        
        init(_ firstQuality: Int, _ secondQuality:Int, _ thirdQuality: Int, _ forthQuality: Int , id: Int) {
            self.firstQuality = firstQuality
            self.secondQuality = secondQuality
            self.thirdQuality = thirdQuality
            self.forthQuality = forthQuality
            self.id = id
        }
        
        subscript(index: Int) -> Int {
            assert(index >= 1 && index <= 4)
            switch index {
            case 1: return firstQuality
            case 2: return secondQuality
            case 3: return thirdQuality
            case 4: return forthQuality
            default: return -1
            }
        }
    }
}
