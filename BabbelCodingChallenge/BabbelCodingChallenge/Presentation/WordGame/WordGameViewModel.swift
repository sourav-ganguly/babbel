//
//  WordGameViewModel.swift
//  BabbelCodingChallenge
//
//  Created by Sourav Ganguly on 27/4/22.
//

import Foundation
import Combine


protocol WordGameViewModelType {
    var wordsCouplePublisher: Published<(englishName: String, spanishName: String)>.Publisher  { get }
    var scorePublisher: Published<Int>.Publisher  { get }
    var bannerTextPublisher: Published<String>.Publisher  { get }
    var shownWordsCountPublisher: Published<Int>.Publisher  { get }
    
    func selectTranslation(state: Bool)
}

class WordGameViewModel: WordGameViewModelType {
    let wordsRepository: WordsRepository
    var wordGame: WordGame
    
    @Published var score: Int = 0
    var scorePublisher: Published<Int>.Publisher { $score }
    
    @Published var shownWordsCount: Int = 0
    var shownWordsCountPublisher: Published<Int>.Publisher  { $shownWordsCount }
    
    @Published var bannerText: String = .initialBannerText
    var bannerTextPublisher: Published<String>.Publisher  { $bannerText }
    
    @Published var wordsCouple: (englishName: String, spanishName: String)  = ("", "")
    var wordsCouplePublisher: Published<(englishName: String, spanishName: String)>.Publisher { $wordsCouple }
    
    private var gameTimer: Timer?
    
    init(wordsRepository: WordsRepository) {
        self.wordsRepository = wordsRepository
        self.wordGame = WordGame()
        
        wordsRepository.getWords { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let words):
                self.wordGame.words = words
                self.wordGame.gameLength = .gameLength
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: .timerDuration, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.bannerText = ""
            self.wordGame.nextMove()
            
            if self.wordGame.isGameOver {
                self.wordsCouple = ("", "")
                self.bannerText = .finalBannerText
                self.wordGame.reset()
                timer.invalidate()
                return
            }
            
            self.shownWordsCount = self.wordGame.shownWordsCount
            self.wordsCouple = (self.wordGame.currentEnglishWord, self.wordGame.currentSpanishWord)
            print(self.wordsCouple)
        }
    }
    
    func selectTranslation(state: Bool) {
        wordGame.selectTranslation(status: state)
        self.score = wordGame.score
    }
}

// MARK: Constants
fileprivate extension Double {
    static let timerDuration = 6.0
}

fileprivate extension Int {
    static let gameLength = 20
}

fileprivate extension String {
    static let initialBannerText = "Select YES if the floating translation is correct, otherwise select NO. +1 for correct answer, -1 for wrong answer. After 20 chances, GAME is OVER"
    static let finalBannerText = "Game Over!"
}
