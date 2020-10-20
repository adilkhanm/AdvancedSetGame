//
//  MainView.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/27/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import UIKit

protocol LayoutViews: class {
	func updateViewFromModel()
}

class MainView: UIView {
	
	weak var delegate: LayoutViews?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		delegate?.updateViewFromModel()
	}
	
}
