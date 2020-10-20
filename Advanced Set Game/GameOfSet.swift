//
//  GameOfSet.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/27/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import Foundation

class GameOfSet {
	
	private var deck = DeckOfCards()
	private(set) var cardsOnTable = [SetCard]()
	
	private(set) var setsCollected: Int = 0
	
	init() {
		cardsOnTable = deck.takeCards(n: 12)!
	}
	
	var hints: [[SetCard]] {
		var hints = [[SetCard]]()
		for index1 in 0..<(cardsOnTable.count - 2) {
			for index2 in (index1 + 1)..<(cardsOnTable.count - 1) {
				for index3 in (index2 + 1)..<cardsOnTable.count {
					let cards = [cardsOnTable[index1], cardsOnTable[index2], cardsOnTable[index3]]
					if let doMatch = doMatch(cards: cards), doMatch == true {
						hints.append(cards)
					} 
				}
			}
		}
		return hints
	}
	
	func add3CardsToGame() -> [SetCard]? {
		if let newCards = deck.takeCards(n: 3) {
			cardsOnTable += newCards
			return newCards
		} else {
			return nil
		}
	}
	
	func doMatch(cards: [SetCard], forReal isReal: Bool = false) -> Bool? {
		if cards.count != 3 {
			return nil
		}
		var sumMatrix = Array.init(repeating: 0, count: cards[0].matrixOfAttributes.count)
		for card in cards {
			for index in sumMatrix.indices {
				sumMatrix[index] += card.matrixOfAttributes[index]
			}
		}
		
		if (sumMatrix.filter { $0 % 3 != 0 }).isEmpty {
			if isReal {
				setsCollected += 1
			}
			return true
		} else {
			return false
		}
	}
	
	func handleCardsChoice(_ cards: [SetCard]) -> Bool? {
		if let doTheyMatch = doMatch(cards: cards) {
			if doTheyMatch == true {
				for card in cards {
					cardsOnTable.remove(at: cardsOnTable.firstIndex(of: card)!)
				}
				return true
			}
			return false
		} else {
			return nil
		}
	}
	
}
