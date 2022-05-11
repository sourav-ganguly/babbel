//
//  Game.swift
//  BabbelCodingChallenge
//
//  Created by Sourav Ganguly on 11/5/22.
//

import Foundation

protocol WordGameType {
    var gameLength: Int! { get set }
    var words: [Word]! { get set }
    var shownWordsCount: Int { get }
    var isGameOver: Bool { get }
    var currentEnglishWord: String { get }
    var currentSpanishWord: String { get }
    var score: Int { get }
    
    func nextMove()
    func selectTranslation(status: Bool)
    func reset()
}

class WordGame: WordGameType {
    var gameLength: Int!
    var words: [Word]!
    
    
    var shownWordsCount = 0
    var isGameOver: Bool {
        shownWordsCount > gameLength
    }
    var currentEnglishWord = ""
    var currentSpanishWord = ""
    var score = 0
    
    private var isCurrectTranslation = false
    private var alreadySelected = true
    
    
    func nextMove() {
        guard !isGameOver else { return }
        alreadySelected = false
        shownWordsCount += 1
        
        let randomNumber = Int.random(in: 0..<words.count)
        self.isCurrectTranslation = Bool.random()
        currentEnglishWord = self.words[randomNumber].textEnglish
        if self.isCurrectTranslation == true {
            currentSpanishWord = self.words[randomNumber].textSpanish
        } else if self.isCurrectTranslation == false {
            currentSpanishWord = randomNumber < self.words.count - 1 ? self.words[randomNumber + 1].textSpanish : self.words[randomNumber - 1].textSpanish
        } else {
            currentSpanishWord = ""
        }
    }
    
    func selectTranslation(status: Bool) {
        guard !alreadySelected
        else {
            return
        }
        if (isCurrectTranslation == status) {
            self.score = self.score + 1
        } else if self.score > 0 {
            self.score = self.score - 1
        }
        alreadySelected = true
    }
    
    func reset() {
        gameLength = 0
        words = []
        shownWordsCount = 0
        isCurrectTranslation = false
        currentEnglishWord = ""
        currentSpanishWord = ""
        alreadySelected = true
        score = 0
    }
}
