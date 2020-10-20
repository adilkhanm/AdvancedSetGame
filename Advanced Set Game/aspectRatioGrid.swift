//
//  aspectRationGrid.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/28/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import UIKit

struct AspectRatioGrid {

	private var bounds: CGRect { didSet { calculateGrid() } }
	private var noOfFrames: Int { didSet { calculateGrid() } }
	
	static var idealAspectRatio: CGFloat = 0.7
	
	private var cellFrames: [CGRect] = []
	
	subscript(index: Int) -> CGRect? {
		return cellFrames.count > index ? cellFrames[index] : nil
	}
	
	private struct GridDimensions: Comparable {
		
		static func <(lhs: GridDimensions, rhs: GridDimensions) -> Bool {
			return (lhs.aspectRatio - idealAspectRatio).abs > (rhs.aspectRatio - idealAspectRatio).abs
		}
		
		var cols: Int
		var rows: Int
		var frameSize: CGSize
		var aspectRatio: CGFloat {
			return frameSize.width / frameSize.height
		}
		
	}
	
	private var bestGridDimensions: GridDimensions?
	
	init(for bounds: CGRect, withNoOfFrames: Int, forIdeal aspectRatio: CGFloat = AspectRatioGrid.idealAspectRatio) {
		self.bounds = bounds
		self.noOfFrames = withNoOfFrames
		AspectRatioGrid.idealAspectRatio = aspectRatio
		calculateGrid()
	}
	
	private mutating func calculateGridDimensions() {
		for cols in 1...noOfFrames {
			let rows: Int = (noOfFrames % cols != 0 ? 1 : 0) + noOfFrames / cols
			
			let currentGridDimensions = GridDimensions(cols: cols, rows: rows, frameSize: CGSize(width: bounds.width / CGFloat(cols), height: bounds.height / CGFloat(rows)))
			
			if let bestGridDimensions = self.bestGridDimensions, bestGridDimensions > currentGridDimensions {
				continue
			} else {
				self.bestGridDimensions = currentGridDimensions
			}
		}
	}
	
	private mutating func calculateGrid() {
		var grid = [CGRect]()
		calculateGridDimensions()
		
		if let gridDimensions = bestGridDimensions {
			
			for rows in 0..<gridDimensions.rows {
				for cols in 0..<gridDimensions.cols {
					let origin = CGPoint(x: CGFloat(cols) * gridDimensions.frameSize.width, y: CGFloat(rows) * gridDimensions.frameSize.height)
					let rect = CGRect(origin: origin, size: gridDimensions.frameSize)
					grid.append(rect)
				}
			}
			
			self.cellFrames = grid
		}
		
	}
	
}

extension CGFloat {
	var abs: CGFloat {
		return self < 0 ? -self : self
	}
}
