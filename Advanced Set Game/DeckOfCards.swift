//
//  DeckOfCards.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/27/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import Foundation

struct DeckOfCards {
	
	var cards: [SetCard]

	init() {
		let rangeOfThree = 1...3
		cards = []
		for n in rangeOfThree {
			for c in rangeOfThree {
				for f in rangeOfThree {
					for s in rangeOfThree {
						cards.append(SetCard(with: n, c, f, s))
					}
				}
			}
		}
	}
	
	mutating func takeCards(n: Int) -> [SetCard]? {
		if n > cards.count {
			return nil
		}
		
		var cards = [SetCard]()
		for _ in 1...n {
			cards.append(self.cards.remove(at: self.cards.count.arc4random))
		}
		return cards
	}
}

extension Int {
	var arc4random: Int {
		if self < 0 {
			return -Int(arc4random_uniform(UInt32(-self)))
		} else if self > 0 {
			return Int(arc4random_uniform(UInt32(self)))
		} else {
			return 0
		}
	}
}
