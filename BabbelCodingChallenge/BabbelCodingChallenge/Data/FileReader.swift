//
//  Networking.swift
//  FabTechnicalTest
//
//  Created by Sourav Ganguly on 28/4/22.
//

import Foundation

enum FileReadError: Error {
    case invalidURL
    case missingData
}

protocol FileReader {
    func readData<T: Decodable>(fileName: String, completion: @escaping (Result<T,Error>) -> Void)
}

class FileReaderImpl: FileReader {
    func readData<T: Decodable>(fileName: String, completion: @escaping (Result<T,Error>) -> Void) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            completion(.failure(FileReadError.invalidURL))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            completion( Result {
                try JSONDecoder().decode(T.self, from: data)
            })
        } catch {
            print("Error!! Unable to parse  \(fileName).json")
            completion(.failure(FileReadError.missingData))
            return
        }
    }
}


