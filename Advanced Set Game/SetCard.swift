//
//  SetCard.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/27/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import Foundation

struct SetCard: Equatable {
	
	let number: Numbers
	let color: Colors
	let fill: Fills
	let shape: Shapes
	
	init(with n: Int, _ c: Int, _ f: Int, _ s: Int) {
		number = Numbers(rawValue: n)!
		color = Colors(rawValue: c)!
		fill = Fills(rawValue: f)!
		shape = Shapes(rawValue: s)!
	}
	
	private static var identifierFactory = 0
	
	let identifier: Int = {
		identifierFactory += 1
		return  identifierFactory
	}()
	
	static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
		return lhs.identifier == rhs.identifier
	}

	var matrixOfAttributes: [Int] {
		return [number.rawValue, color.rawValue, fill.rawValue, shape.rawValue]
	}
	
}

enum Numbers: Int {
	case one = 1, two, three
}

enum Colors: Int {
	case red = 1, green, blue
}

enum Fills: Int {
	case empty = 1, filled, striped
}

enum Shapes: Int {
	case square = 1, triangle, circle
}
