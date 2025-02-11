//
//  WordList.swift
//  wordle
//
//  Created by Lynjai Jimenez on 2/10/25.
//

import Foundation

struct WordList {
    // Array to store all possible answers
    static let answers: [String] = [
        "ULTRA", "STARE", "HOUSE", "PLANT", "EARTH",
        "WATER", "SMILE", "BEACH", "DREAM", "BRAIN",
        "CLOUD", "DANCE", "EARLY", "FLAME", "GRAPE",
        "HAPPY", "LIGHT", "MUSIC", "OCEAN", "PEACE",
        "QUICK", "ROUND", "SHINE", "TRAIN", "VOICE",
        "WORLD", "YOUTH", "BREAD", "CLOCK", "DRIVE",
        "FRESH", "GREEN", "HEART", "IDEAL", "MAGIC",
        "NIGHT", "PAINT", "QUIET", "RIVER", "SPARK",
        "SWEET", "TIGER", "URBAN", "VALUE", "WHEAT",
        "YOUNG", "CHARM", "CLIMB", "STORM", "SPACE",
    ]

    // Get a random word from the list
    static func getRandomWord() -> String {
        return answers.randomElement() ?? "AFTER"
    }

    // Check if a word exists in our list
    static func isValidWord(_ word: String) -> Bool {
        return answers.contains(word.uppercased())
    }
}
