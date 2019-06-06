import Foundation
import UIKit

struct Word {
    var original: String
    var charArray: [Character]
    var scrambledArray = [Character]()
    var length: Int
    
    init(original: String) {
        self.original = original
        charArray = Array(original)
        length = original.count
    }
    
    mutating func changeWord(newWord: String) {
        self.original = newWord
        charArray = Array(newWord)
        length = newWord.count
    }
    
    mutating func scramble() {
        scrambledArray.removeAll()
        for c in charArray {
            scrambledArray.append(c)
        }
        scrambledArray.shuffle()
    }
}
