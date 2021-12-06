/// Day 4: Giant Squid


/*
 Lösungsansatz:
 Jedes Board hat eine funktion, welches die gezogene Zahl markieren kann und im Fall, dass eine Reihe/Spalte fertig ist, True als Boolean zurückgibt.
 Zu beginn wird das Board in eine Lange liste gespeichert -> (Hier beispiel 3x3 statt 5x5)
 
 Aus
 
 1 2 3
 4 5 6
 7 8 9
 
 Wird
 
 1 2 3 4 5 6 7 8 9
 
 Wenn eine Zahl gezogen wird, welche am Bord Verfügbar ist, dann wird der Index der Zahl von der Zahlenreihe zur Liste der Gezogenen hinuzgefügt. Um zu kontrollieren, ob es fertige Reihen/Spalten gibt, gibt es zwei ansätze:
 
 1. Man kontrolliert, ob es Indexes 0/1/2, 3/4/5, 6/7/8 gibt (reihen) oder 0/3/6, 1/4/7, 2/5/8 (spalten). Bei den Spalten könnte man testen, ob es 3 Werte gibt, welche X % 3 - N gibt, wo X die Zahl und N die Spaltennummer ist.
 2. Es gibt für alle Möglichkeiten eine Zahl (Maske), welche bei einer Bitweisen & (UND) Rechnung den Gleichen Wert wie die Maske wieder bekommt. In dem Fall, sind die Indexe für eine fertige Reihe/Spalte verfügbar.
 
 Das Board hat auch die Funktion, alle markierten und unmarkierten Zahlen zurückzugeben, zu jedem Zeitpunkt.
 Weil man genau weiß, wie viele Indexe es gibt und welche schon gezogen wurde, kann man einfach die übergebliebenen herausfinden.
 
 Wenn ein Bord Fertig ist, kann diese Info und die zuletz gezogene Zahl (welche das Bingo System kennt) benutzen, um die Lösung zu berechnen.
 
 */

import Foundation
import Helpers

struct Board {
    private let rawNumbers: String
    let boardNumbers: [Int]
    let boardNumbersCount: Int
    let rowCount: Int
    let columnCount: Int
    
    var markedMask: Int
    
    init(_ board: String) {
        self.rawNumbers = board
        let rows = board.components(separatedBy: "\n")
        self.rowCount = rows.count
        let columns = rows.map { $0.components(separatedBy: " ").filter { $0 != "" } }
        self.columnCount = columns[0].count
        self.boardNumbers = columns.flatMap { $0 }.map { Int($0)! }
        self.boardNumbersCount = self.boardNumbers.count
        
        self.markedMask = 0
    }
    
    mutating func mark(number: Int) -> Bool {
        let numberIndex = self.boardNumbers.firstIndex(of: number)
        
        if (numberIndex != nil) {
            let position = boardNumbers.count - numberIndex! - 1
            
            let binaryNumber = 2.pow(to: position)
            
            markedMask = markedMask | binaryNumber
            
            return testIfFinished()
        } else {
            return false
        }
    }
    
    lazy var testMasks: [Int] = {
        var masks: [Int] = []
        
        for row in 0..<rowCount {
            let start = (row * columnCount)
            let end = ((row + 1) * columnCount) - 1
            
            let mask = (start...end)
                .map { 2.pow(to: $0) }
                .reduce(0, |)
            
            masks.append(mask)
        }
        
        for column in 0..<columnCount {
            let mask = (0..<boardNumbersCount)
                .map { Int(exactly: $0)! }
                .filter { $0 % 5 == column }
                .map { 2.pow(to: $0) }
                .reduce(0, |)
            
            masks.append(mask)
        }
                
        return masks
    }()
    
    mutating func testIfFinished() -> Bool {
        for mask in testMasks {
            if (mask == (markedMask & mask)) {
                return true
            }
        }
        
        return false
    }
    
    func numbers(marked showMarked: Bool) -> [Int] {
        var numbers: [Int] = []
        for index in 0..<boardNumbersCount {
            let mask = 2.pow(to: boardNumbersCount - 1 - index)
            let check = showMarked ? mask : 0
            if (check == (markedMask & mask)) {
                numbers.append(boardNumbers[index])
            }
        }
        return numbers
    }
}

struct Bingo {
    let drawNumbers: [Int]
    var boards: [Board]
    var turn = 0
    
    init(rawBingoInput: String) {
        var parts = rawBingoInput.components(separatedBy: "\n\n")
        
        let rawDrawNumbers = parts.removeFirst()
        self.drawNumbers = rawDrawNumbers
            .components(separatedBy: ",")
            .filter { $0 != "" }
            .map { Int($0)! }
        
        self.boards = parts.map { Board($0) }
    }
    
    mutating func drawNumber() -> (Int, Board)? {
        let number = drawNumbers[turn]
        
        for boardIndex in 0..<boards.endIndex {
            let isFinished = boards[boardIndex].mark(number: number)
            if (isFinished) {
                return (number, boards[boardIndex])
            }
        }
        
        turn += 1
        
        return nil
    }
    
    mutating func drawNumbersUntilWinner() -> Void {
        for _ in 0..<drawNumbers.endIndex {
            let draw = drawNumber()
            
            if (draw != nil) {
                let lastNumber = draw!.0
                let winnerBoard = draw!.1
                let unmarkedNumbers = winnerBoard.numbers(marked: false)
                let score = lastNumber * unmarkedNumbers.reduce(0, +)
                print("Winning Board found in Turn \(turn): \(score)")
                
                return
            }
        }
        
        print("No Winning Board found")
    }
    
    mutating func drawNumbersUntilAllFinish() -> Void {
        var finishedBoardsIndexes: [Int] = []
        
        for drawTurn in 0..<drawNumbers.endIndex {
            let number = drawNumbers[drawTurn]
            
            for boardIndex in 0..<boards.endIndex {
                if (!finishedBoardsIndexes.contains(boardIndex)) {
                    let isFinished = boards[boardIndex].mark(number: number)
                    if (isFinished) {
                        finishedBoardsIndexes.append(boardIndex)
                    }
                }
            }
            
            if (finishedBoardsIndexes.count == boards.count) {
                let lastNumber = number
                let lastBoard = boards[finishedBoardsIndexes.last!]
                let unmarkedNumbers = lastBoard.numbers(marked: false)
                let score = lastNumber * unmarkedNumbers.reduce(0, +)
                print("Last finishing Board found in Turn \(drawTurn): \(score)")

                return
            }
        }
        
        print("No finishing Board found")
    }
}

let exampleBingo = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

var exampleGame = Bingo(rawBingoInput: exampleBingo)
exampleGame.drawNumbersUntilWinner()
exampleGame.drawNumbersUntilAllFinish()

let inputBingo = Bundle.module.loadTextdataFromFile(name: "input04")

var inputGame = Bingo(rawBingoInput: inputBingo)
inputGame.drawNumbersUntilWinner()
inputGame.drawNumbersUntilAllFinish()
