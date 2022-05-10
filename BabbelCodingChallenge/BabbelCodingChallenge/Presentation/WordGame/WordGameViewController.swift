//
//  WordGameViewController.swift
//  BabbelCodingChallenge
//
//  Created by Sourav Ganguly on 26/4/22.
//

import UIKit
import Combine

class WordGameViewController: UIViewController {
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negetiveButton: UIButton!
    @IBOutlet weak var spanishWord: UILabel!
    @IBOutlet weak var englishWord: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var viewModel: WordGameViewModelType!
    private var gameTimer: Timer?
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        negetiveButton.layer.cornerRadius = 0
        positiveButton.layer.cornerRadius = 0
        
        subscribeToViewModel()
    }
    
    //MARK: Actions
    @IBAction func didTapOnNegetiveButton(_ sender: Any) {
        viewModel.selectTranslation(state: false)
    }
    
    @IBAction func didTapOnPositiveButton(_ sender: Any) {
        viewModel.selectTranslation(state: true)
    }
    
    //MARK: Private Methods
    private func subscribeToViewModel() {
        viewModel.wordsCouplePublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] wordCouple in
                self?.animateWith(english: wordCouple.englishName,
                                  spanish: wordCouple.spanishName)
            }
            .store(in: &cancellables)
        
        viewModel.scorePublisher
            .combineLatest(viewModel.shownWordsCountPublisher)
            .receive(on: RunLoop.main)
            .sink { [weak self] gameScore, wordCount in
                self?.scoreLabel?.text = "Score: \(gameScore) in \(wordCount)"
            }
            .store(in: &cancellables)
        
        viewModel.bannerTextPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] bannerText in
                self?.instructionLabel?.text = bannerText
            }
            .store(in: &cancellables)
    }
    
    private func animateWith(english: String, spanish: String) {
        englishWord.text = english
        spanishWord.text = spanish
        UIView.animate(withDuration: .animationDuration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.spanishWord.transform = CGAffineTransform(translationX: self.spanishWord.bounds.origin.x, y: self.spanishWord.bounds.origin.y + .screenHeight)
        }, completion: { [weak self] _ in
            self?.spanishWord.transform = CGAffineTransform.identity
            self?.englishWord.text = ""
            self?.spanishWord.text = ""
        })
    }
    
}

// MARK: Constants
fileprivate extension Double {
    static let animationDuration = 5.0
    static let screenHeight = 1000.0
}
