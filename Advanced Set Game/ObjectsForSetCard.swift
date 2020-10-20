//
//  ObjectsForSetCard.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/28/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import UIKit

struct ObjectsForSetCard {

	let numberOfObjects: Int
	let maxNumberOfObjects: Int
	let shape: Shapes
	let fillFactory: CGFloat
	let numberOfStripes = 8
	
	private let height: CGFloat
	private let width: CGFloat
	
	var objectSide: CGFloat {
		return min(fillFactory * height / CGFloat(maxNumberOfObjects), fillFactory * width)
	}
	
	private var spaceBetweenObjects: CGFloat {
		return (height - objectSide * CGFloat(maxNumberOfObjects)) / (CGFloat(maxNumberOfObjects + 1))
	}
	
	init(in rect: CGRect, for objectType: Shapes, numberOfObjects: Int, maxNumberOfObjects: Int = 3, fillFactory: CGFloat = 0.65) {
		
		height = rect.height
		width = rect.width
		
		self.numberOfObjects = numberOfObjects
		self.shape = objectType
		self.maxNumberOfObjects = maxNumberOfObjects
		self.fillFactory = fillFactory
	}
	
	private var objectsOrigins: [CGPoint] {
		var origins: [CGPoint] = []
		
		let y0: CGFloat = (height - objectSide * CGFloat(numberOfObjects) - spaceBetweenObjects * CGFloat(numberOfObjects - 1)) / 2.0
		let x: CGFloat = (width - objectSide) / 2.0
		
		for n in 0..<numberOfObjects {
			origins.append(CGPoint(x: x, y: y0 + CGFloat(n) * (objectSide + spaceBetweenObjects)))
		}
		
		return origins
	}
	
	private var objectsCenters: [CGPoint] {
		var centers: [CGPoint] = []
		
		let delta = CGPoint(x: objectSide / 2, y: objectSide / 2)
		for objectOrigin in objectsOrigins {
			centers.append(objectOrigin + delta)
		}
		
		return centers
	}
	
	private var stripesForObjects: [[(p1: CGPoint, p2: CGPoint)]] {
		var allStripes = [[(CGPoint, CGPoint)]]()
		
		let delta = (objectSide * 2) / CGFloat(numberOfStripes + 1)
		
		for origin in objectsOrigins {
			
			var stripes = [(CGPoint, CGPoint)]()
			for n in 1...((numberOfStripes + 1) / 2) {
				var p1 = CGPoint(x: origin.x + delta * CGFloat(n), y: origin.y)
				var p2 = CGPoint(x: origin.x, y: origin.y + delta * CGFloat(n))
				stripes.append((p1, p2))
				
				if (n * 2 <= numberOfStripes) {
					p1 = CGPoint(x: origin.x + objectSide - delta * CGFloat(n), y: origin.y + objectSide)
					p2 = CGPoint(x: origin.x + objectSide, y: origin.y + objectSide - delta * CGFloat(n))
					stripes.append((p1, p2))
				}
			}
			allStripes.append(stripes)
		}
		
		return allStripes
	}
	
	var bezierPath: UIBezierPath {
		let paths = UIBezierPath()
		switch shape {
		case .circle:
			for center in objectsCenters {
				let bezierPath = UIBezierPath(arcCenter: center, radius: objectSide / 2, startAngle: 0.0, endAngle: .pi * 2, clockwise: true)
				paths.append(bezierPath)
			}
		case .square:
			for origin in objectsOrigins {
				let bezierPath = UIBezierPath(rect: .init(origin: origin, size: .init(width: objectSide, height: objectSide)))
				paths.append(bezierPath)
			}
		case .triangle:
			for origin in objectsOrigins {
				let point1 = CGPoint(x: origin.x + objectSide / 2, y: origin.y)
				let point2 = CGPoint(x: origin.x + objectSide, y: origin.y + objectSide)
				let point3 = CGPoint(x: origin.x, y: origin.y + objectSide)
				
				let bezierPath = UIBezierPath()
				bezierPath.move(to: point1)
				bezierPath.addLine(to: point2)
				bezierPath.addLine(to: point3)
				bezierPath.close()
				
				paths.append(bezierPath)
			}
		}
		return paths
	}
	
	var stripesBezierPath: UIBezierPath {
		let paths = UIBezierPath()
		for stripes in stripesForObjects {
			for (p1, p2) in stripes {
				paths.move(to: p1)
				paths.addLine(to: p2)
			}
		}
		return paths
	}

}

extension CGPoint {
	static func +(p1: CGPoint, p2: CGPoint) -> CGPoint {
		return .init(x: p1.x + p2.x, y: p1.y + p2.y)
	}
}
