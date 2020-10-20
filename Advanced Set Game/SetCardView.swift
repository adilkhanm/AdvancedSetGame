//
//  SetCardView.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/27/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import UIKit

class SetCardView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.clipsToBounds = true
		setBasicLayoutForBorder()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.clipsToBounds = true
		setBasicLayoutForBorder()
	}
	
	private func setBasicLayoutForBorder() {
		layer.borderWidth = LayoutMetricsForCardView.borderWidth
		layer.borderColor = LayoutMetricsForCardView.borderColor
		layer.cornerRadius = LayoutMetricsForCardView.cornerRadius
	}
	
	var card: SetCard!
	
	private let objectSizeToLineRatio: CGFloat = 15.0
	
    override func draw(_ rect: CGRect) {
		if let card = self.card {
			
			var color = UIColor();
			switch card.color {
			case .red: color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
			case .blue: color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
			case .green: color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
			}
			
			color.setFill()
			color.setStroke()
			
			
			let objects = ObjectsForSetCard(in: rect, for: card.shape, numberOfObjects: card.number.rawValue)
			
			let objectsOutline = objects.bezierPath
			objectsOutline.lineWidth = objects.objectSide / objectSizeToLineRatio
			objectsOutline.stroke()
			
			switch card.fill {
			case .empty: break
			case .filled: objectsOutline.fill()
			case .striped: 
				objectsOutline.addClip()
				let stripes = objects.stripesBezierPath
				stripes.lineWidth = objects.objectSide / objectSizeToLineRatio / 2
				stripes.stroke()
			}
			
		}
    }
	
	var stateOfCard: StateOfCard = .unselected {
		didSet {
			switch stateOfCard {
			case .unselected: layer.borderColor = LayoutMetricsForCardView.borderColor
			case .selected: layer.borderColor = LayoutMetricsForCardView.selectedBorderColor
			case .matched: layer.borderColor = LayoutMetricsForCardView.matchedBorderColor
			case .mismatched: layer.borderColor = LayoutMetricsForCardView.mismatchedBorderColor
			case .hinted: layer.borderColor = LayoutMetricsForCardView.hintedBorderColor
			}
			
			switch stateOfCard {
			case .unselected: layer.borderWidth = LayoutMetricsForCardView.borderWidth
			default: layer.borderWidth = LayoutMetricsForCardView.uncommonBorderWidth 
			}
		}
	}
	
	enum StateOfCard {
		case unselected, selected, matched, mismatched, hinted
	}
	
}

struct LayoutMetricsForCardView {
	
	static var borderWidth: CGFloat = 1.0
	static var uncommonBorderWidth: CGFloat = 4.0
	
	static var borderColor: CGColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
	static var selectedBorderColor: CGColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
	static var matchedBorderColor: CGColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).cgColor
	static var mismatchedBorderColor: CGColor = #colorLiteral(red: 1, green: 0.3728244305, blue: 0.3214324713, alpha: 1).cgColor
	static var hintedBorderColor: CGColor = #colorLiteral(red: 0, green: 0.2359027863, blue: 0.4132848382, alpha: 1).cgColor
	
	static var cornerRadius: CGFloat = 8.0
	
}
