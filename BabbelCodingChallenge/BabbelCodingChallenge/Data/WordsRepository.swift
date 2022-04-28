//
//  WordsRepository.swift
//  BabbelCodingChallenge
//
//  Created by Sourav Ganguly on 28/4/22.
//

import Foundation

protocol WordsRepository {
    func getWords(completion: @escaping (Result<[Word],Error>) -> Void)
}

class WordsRepositoryImpl: WordsRepository {
    let reader: FileReader = FileReaderImpl()
    func getWords(completion: @escaping (Result<[Word], Error>) -> Void) {
        return reader.readData(fileName: "words", completion: completion)
    }
}
