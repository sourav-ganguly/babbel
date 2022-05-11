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
        XCTAssertEqual(sut.score, 0)
    }
    
    func testWordGame_whenReset_scoreIsZero() {
        givenGameInitialized()
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: answer)
        sut.reset()
        XCTAssertEqual(sut.score, 0)
    }
    
    func testWordGame_whenSelectCurrectFirstTime_scoreIsOne() {
        givenGameInitialized()
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: answer)
        XCTAssertEqual(sut.score, 1)
    }
    
    func testWordGame_whenSelectCurrectFiveTimesInStart_scoreIsFive() {
        givenGameInitialized()
        
        for _ in 0..<5 {
            sut.nextMove()
            let answer = sut.currentEnglishWord == sut.currentSpanishWord
            sut.selectTranslation(status: answer)
        }
        XCTAssertEqual(sut.score, 5)
    }
    
    func testWordGame_whenSelectIncurrectFirstTime_scoreIsZero() {
        givenGameInitialized()
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: !answer)
        XCTAssertEqual(sut.score, 0)
    }
    
    func testWordGame_whenSelectCurrectInProgress_scoreIncreaseByOne() {
        givenGameInitialized()
        givenGameInProgress()
        let previousScore = sut.score
        
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: answer)
        XCTAssertEqual(sut.score, previousScore + 1)
    }
    
    func testWordGame_whenSelectIncurrectInProgress_scoreDecreaseByOne() {
        givenGameInitialized()
        givenGameInProgress()
        let previousScore = sut.score
        
        sut.nextMove()
        let answer = sut.currentEnglishWord == sut.currentSpanishWord
        sut.selectTranslation(status: !answer)
        XCTAssertEqual(sut.score, previousScore - 1)
    }
    
    func testWordGame_whenSelectMoveLessThanGameMove_gameOverStatusFalse() {
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
    
    func testWordGame_whenSelectMoveEqualToGameMove_gameOverStatusTrue() {
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
        XCTAssertTrue(sut.isGameOver)
    }
    
    func testWordGame_whenStarted_gameOverStatusTrue() {
        givenGameInitialized()

        XCTAssertFalse(sut.isGameOver)
    }
}
