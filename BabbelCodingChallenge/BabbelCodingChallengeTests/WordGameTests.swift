//
//  WordGameTests.swift
//  BabbelCodingChallengeTests
//
//  Created by Sourav Ganguly on 11/5/22.
//

import XCTest
@testable import BabbelCodingChallenge

class WordGameTests: XCTestCase {
    var sut: WordGame!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = WordGame()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func givenGameInitialized() {
        sut.words = [
            Word(english: "a", spanish: "a"),
            Word(english: "b", spanish: "b")
        ]
        sut.gameLength = 10
    }
    
    func givenGameInProgress() {
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: answer)
        
        sut.nextMove()
        let secondAnswer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: secondAnswer)
        
        sut.nextMove()
        let thirdAnswer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: thirdAnswer)
    }
    
    func testWordGame_whenStarted_scoreIsZero() {
        givenGameInitialized()
        XCTAssertEqual(sut.score, 0)
    }
    
    func testWordGameInProgress_whenReset_scoreIsZero() {
        givenGameInitialized()
        givenGameInProgress()
        sut.reset()
        XCTAssertEqual(sut.score, 0)
    }
    
    func testWordGameInitialized_whenSelectCurrect_scoreIsOne() {
        givenGameInitialized()
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: answer)
        XCTAssertEqual(sut.score, 1)
    }
    
    func testWordGameInitialized_whenSelectCurrectFiveTimes_scoreIsFive() {
        givenGameInitialized()
        
        for _ in 0..<5 {
            sut.nextMove()
            let answer = sut.currentEnglishWord == sut.currentSpanishWord
            sut.selectTranslation(status: answer)
        }
        XCTAssertEqual(sut.score, 5)
    }
    
    func testWordGameInitialized_whenSelectIncurrect_scoreIsZero() {
        givenGameInitialized()
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: !answer)
        XCTAssertEqual(sut.score, 0)
    }
    
    func testWordGameInProgress_whenSelectCurrect_scoreIncreaseByOne() {
        givenGameInitialized()
        givenGameInProgress()
        let previousScore = sut.score
        
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: answer)
        XCTAssertEqual(sut.score, previousScore + 1)
    }
    
    func testWordGameInProgress_whenSelectIncurrect_scoreDecreaseByOne() {
        givenGameInitialized()
        givenGameInProgress()
        let previousScore = sut.score
        
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: !answer)
        XCTAssertEqual(sut.score, previousScore - 1)
    }
    
    func testWordGameInitialized_whenSelectMoveLessThanGameLength_gameOverStatusFalse() {
        sut.words = [
            Word(english: "a", spanish: "a"),
            Word(english: "b", spanish: "b")
        ]
        sut.gameLength = 5
        
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        XCTAssertFalse(sut.isGameOver)
    }
    
    func testWordGameInitialized_whenSelectMoveEqualToGameLength_gameOverStatusFalse() {
        sut.words = [
            Word(english: "a", spanish: "a"),
            Word(english: "b", spanish: "b")
        ]
        sut.gameLength = 5
        
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        XCTAssertFalse(sut.isGameOver)
    }
    
    func testWordGameInitialized_whenSelectMoveGreatThanGameLength_gameOverStatusTrue() {
        sut.words = [
            Word(english: "a", spanish: "a"),
            Word(english: "b", spanish: "b")
        ]
        sut.gameLength = 5
        
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        sut.nextMove()
        XCTAssertTrue(sut.isGameOver)
    }
    
    func testWordGameInProgress_whenSelectNothing_scoreStaysSame() {
        givenGameInitialized()
        givenGameInProgress()
        let previousScore = sut.score
        
        sut.nextMove()
        sut.nextMove()
        XCTAssertEqual(sut.score, previousScore)
    }
    
    func testWordGameInitilized_whenStarted_gameOverStatusTrue() {
        givenGameInitialized()

        XCTAssertFalse(sut.isGameOver)
    }
}
