//
//  Word.swift
//  BabbelCodingChallenge
//
//  Created by Sourav Ganguly on 28/4/22.
//

import Foundation

// MARK: - Word
struct Word: Codable {
    let textEnglish, textSpanish: String
    
    init(english: String, spanish: String) {
        textEnglish = english
        textSpanish = spanish
    }

    enum CodingKeys: String, CodingKey {
        case textEnglish = "text_eng"
        case textSpanish = "text_spa"
    }
}
