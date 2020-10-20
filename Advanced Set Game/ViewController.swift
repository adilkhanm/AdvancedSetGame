//
//  ViewController.swift
//  Advanced Set Game
//
//  Created by Adilkhan on 5/27/20.
//  Copyright © 2020 Adilkhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LayoutViews {
	
	private var cardButtons: [SetCardView] = []
	private var selectedButtons: [SetCardView] = [] {
		didSet {
			if let doMatch = setGame.doMatch(cards: (selectedButtons.map { $0.card! }), forReal: true) {
				if doMatch == true {
					selectedButtons.forEach { $0.stateOfCard = .matched }
					setsCollectedLabel.text = "Sets Collected: \(setGame.setsCollected)"
				} else {
					selectedButtons.forEach { $0.stateOfCard = .mismatched }
				}
			}
			if selectedButtons.isEmpty {
				oldValue.forEach { $0.stateOfCard = .unselected }
			}
		}
	}
	
	private var hints: (cards: [[SetCard]], hintNumber: Int, cardsShown: Int) = ([[]], 0, 0) {
		didSet {
			if hints.cardsShown == oldValue.cardsShown {
				hintsButton.isEnabled = !hints.cards.isEmpty
				hintsButton.setTitle("Hints (\(hints.cards.count))", for: .normal)
				hints.hintNumber = 0
				hints.cardsShown = 0
				
				lastHint.forEach { $0.stateOfCard = .unselected }
				lastHint = []
			}
		}
	}
	private var lastHint: [SetCardView] = []
	
	@IBOutlet weak var newGameButton: UIButton! { didSet { setBasicLayout(for: newGameButton) } }
	@IBOutlet weak var askMoreCardsButton: UIButton! { didSet { setBasicLayout(for: askMoreCardsButton) } }
	@IBOutlet weak var hintsButton: UIButton! { didSet { setBasicLayout(for: hintsButton) } }
	
	@IBOutlet weak var setsCollectedLabel: UILabel! { didSet { setBasicLayout(for: setsCollectedLabel) } }
	
	private func setBasicLayout(for view: UIView) {
		view.layer.cornerRadius = LayoutMetricsForCardView.cornerRadius 
		view.clipsToBounds = true
	}
	
	@IBOutlet weak var mainView: MainView! {
		didSet {
			mainView.delegate = self
		}
	}
	
	@IBAction func onAskMoreCards(_ sender: UIButton) {
		preHandleCardStates()
		
		if let newCards = setGame.add3CardsToGame() {
			newCards.forEach { addViewForCard($0) }
			hints.cards = setGame.hints 
		} else {
			askMoreCardsButton.isEnabled = false
		}
	}
	
	@IBAction func onHintsButton(_ sender: UIButton) {
		preHandleCardStates()
		selectedButtons.removeAll()
		
		if !hints.cards.isEmpty {
			if hints.cardsShown == 3 {
				hints.cardsShown = 0
				hints.hintNumber = (hints.hintNumber + 1) % hints.cards.count
				lastHint.forEach { $0.stateOfCard = .unselected }
			}
			if hints.cardsShown == 0 {
				lastHint = buttons(for: hints.cards[hints.hintNumber])
			}
			
			lastHint[hints.cardsShown].stateOfCard = .hinted
			hints.cardsShown += 1
		}
	}
	
	@IBAction func onNewGame(_ sender: UIButton) {
		cardButtons.forEach { 
			$0.card = nil
			$0.removeFromSuperview()
		}
		cardButtons = []
		setGame = GameOfSet()
		askMoreCardsButton.isEnabled = true
		setsCollectedLabel.text = "Sets Collected: 0"
		selectedButtons = []
		lastHint = []
	}
	
	private func buttons(for cards: [SetCard]) -> [SetCardView] {
		var buttons: [SetCardView] = []
		for card in cards {
			if let button = (cardButtons.filter { $0.card == card }).first {
				buttons.append(button)
			}
		}
		return buttons
	}
	
	
	private var setGame: GameOfSet! {
		didSet {
			setGame.cardsOnTable.forEach { addViewForCard($0) }
			hints.cards = setGame.hints
		}
	}
	
	internal func updateViewFromModel() {
		let grid = AspectRatioGrid(for: mainView.bounds, withNoOfFrames: setGame.cardsOnTable.count)
		for index in cardButtons.indices {
			let insetXY = (grid[index]?.height ?? 400) / 50
			cardButtons[index].frame = grid[index]?.insetBy(dx: insetXY, dy: insetXY) ?? CGRect.zero
		}
	}
	
	private func addViewForCard(_ card: SetCard) {
		let setCardButton = SetCardView()
		setCardButton.card = card
		
		setCardButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
		setCardButton.contentMode = .redraw
		
		setCardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCardTapGesture)))
		
		cardButtons.append(setCardButton)
		mainView.addSubview(setCardButton)
	}
	
	private func preHandleCardStates(withHints: Bool = false) {
		if let doMatch = setGame.handleCardsChoice(selectedButtons.map { $0.card! } ) {
			if doMatch == true {
				selectedButtons.forEach {
					$0.card = nil
					cardButtons.remove(at: cardButtons.firstIndex(of: $0)!)
					$0.removeFromSuperview()
				}
				hints.cards = setGame.hints
			}
			selectedButtons.removeAll()
		}
		if withHints == true {
			hints.cardsShown = 0
			lastHint.forEach { $0.stateOfCard = .unselected }
			lastHint.removeAll()
		}
	}
	
	@objc private func onCardTapGesture(_ recognizer: UITapGestureRecognizer) {
		
		preHandleCardStates(withHints: true)
		
		guard let tappedCard = recognizer.view as? SetCardView else { return }
		
		print("selectedButtons.count = \(selectedButtons.count)")
		
		if cardButtons.firstIndex(of: tappedCard) == nil {
			return
		}
		
		if tappedCard.stateOfCard == .unselected {
			tappedCard.stateOfCard = .selected
			selectedButtons.append(tappedCard)
		} else {
			tappedCard.stateOfCard = .unselected
			selectedButtons.remove(at: selectedButtons.firstIndex(of: tappedCard)!)
		}
	} 
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setGame = GameOfSet()
	}
	
}

