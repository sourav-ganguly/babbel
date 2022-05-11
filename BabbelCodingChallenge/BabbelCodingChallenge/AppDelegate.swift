//
//  AppDelegate.swift
//  BabbelCodingChallenge
//
//  Created by Sourav Ganguly on 26/4/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.overrideUserInterfaceStyle = .dark
        
        // Dependency Injection
        let storyboard = UIStoryboard(name: .wordGameViewController, bundle: nil)
        guard let wordGameViewController = storyboard.instantiateViewController(withIdentifier: .wordGameViewController) as? WordGameViewController else {
            preconditionFailure("Unable to instantiate a WordGameViewController with the name")
        }
        let wordsRepository = WordsRepositoryImpl()
        let wordGame = WordGame()
        let wordGameViewModel = WordGameViewModel(wordsRepository: wordsRepository, wordGame: wordGame)
        wordGameViewController.viewModel = wordGameViewModel
        
        self.window?.rootViewController = wordGameViewController
        self.window?.makeKeyAndVisible()
        return true
    }

}


fileprivate extension String {
    static let wordGameViewController = "WordGameViewController"
}
