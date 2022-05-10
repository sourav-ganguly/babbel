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
    
    @Published var score: Int = 0
    var scorePublisher: Published<Int>.Publisher { $score }
    
    @Published var shownWordsCount: Int = 0
    var shownWordsCountPublisher: Published<Int>.Publisher  { $shownWordsCount }
    
    @Published var bannerText: String = .initialBannerText
    var bannerTextPublisher: Published<String>.Publisher  { $bannerText }
    
    @Published var wordsCouple: (englishName: String, spanishName: String)  = ("", "")
    var wordsCouplePublisher: Published<(englishName: String, spanishName: String)>.Publisher { $wordsCouple }
    
    private var alreadySelected = false
    private var gameTimer: Timer?
    private var isCurrectTranslation: Bool?
    
    private var words: [Word] = []
    private var nWords: Int {
        words.count
    }
    
    init(wordsRepository: WordsRepository) {
        self.wordsRepository = wordsRepository
        
        wordsRepository.getWords { [weak self] result in
            switch result {
            case .success(let words):
                self?.words = words
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: .timerDuration, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.bannerText = ""
            
            if self.shownWordsCount >= .gameLength {
                self.wordsCouple = ("", "")
                self.bannerText = .finalBannerText
                timer.invalidate()
                return
            }
            
            self.shownWordsCount = self.shownWordsCount + 1
            self.alreadySelected = false
            
            let randomNumber = Int.random(in: 0..<self.nWords)
            self.isCurrectTranslation = Bool.random()
            let englishWord = self.words[randomNumber].textEnglish
            let spanishWord: String
            if self.isCurrectTranslation == true {
                spanishWord = self.words[randomNumber].textSpanish
            } else if self.isCurrectTranslation == false {
                spanishWord = randomNumber < self.nWords - 1 ? self.words[randomNumber + 1].textSpanish : self.words[randomNumber - 1].textSpanish
            } else {
                spanishWord = ""
            }
            self.wordsCouple = (englishWord, spanishWord)
        }
    }
    
    func selectTranslation(state: Bool) {
        guard let selectedState = self.isCurrectTranslation, !alreadySelected
        else {
            return
        }
        if (selectedState == state) {
            self.score = self.score + 1
        } else if self.score > 0 {
            self.score = self.score - 1
        }
        alreadySelected = true
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
