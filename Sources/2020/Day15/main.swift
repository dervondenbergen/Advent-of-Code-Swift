/// Day 15: Rambunctious Recitation

import Foundation

struct Game {
    let startingNumbers: [Int]
    var turns = 0
    var lastSpokenNumber: Int = 0
    var spokenNumbersInTurns = Dictionary<Int, (Int?, Int?)>()
    
    let verbose: Bool
    
    init(_ startingNumbers: String, verbose: Bool = false) {
        self.startingNumbers = startingNumbers.components(separatedBy: ",").map { Int($0)! }
        self.verbose = verbose
        
        print("Game initialized with following start numbers:", self.startingNumbers)
    }
    
    mutating func sayNumber(_ number: Int) -> Void {
        lastSpokenNumber = number
        if (spokenNumbersInTurns[number] == nil) {
            spokenNumbersInTurns[number] = (nil, nil)
        }
        spokenNumbersInTurns[number]!.1 = spokenNumbersInTurns[number]!.0
        spokenNumbersInTurns[number]!.0 = turns
        if (verbose) {
            print("say", number)
        }
    }
    
    mutating func takeTurn() -> Void {
        turns += 1

        if (verbose) {
            print("Turn \(turns):", terminator: " ")
        }
        
        if (turns < startingNumbers.count + 1) {
            let startingNumber = startingNumbers[turns - 1]
            sayNumber(startingNumber)
        } else {
            let lastNumberSpokenTurns = spokenNumbersInTurns[self.lastSpokenNumber]!
            
            if (lastNumberSpokenTurns.1 == nil) {
                sayNumber(0)
            } else {
                let lastTurn = lastNumberSpokenTurns.0!
                let beforeLastTurn = lastNumberSpokenTurns.1!
                let turnDifference = lastTurn - beforeLastTurn
                sayNumber(turnDifference)
                if (verbose) {
                    print("// was already spoken twice", "last", lastTurn, "before last", beforeLastTurn)
                }
            }
        }
    }
    
    mutating func takeTurns(_ amount: Int) -> Void {
        print("Taking multiple Turns: \(amount)")
        let tenth = (amount / 10)
        for i in 1...amount {
            if (i % tenth == 0) {
                print("Turns taken: \((i / tenth))/10")
            }
            takeTurn()
        }
    }
    
    func showLastTurn() -> Void {
        print("Last Turn (\(turns)) was \(lastSpokenNumber)")
    }
}

let exampleStart = "0,3,6"
var exampleGame = Game(exampleStart, verbose: false)
exampleGame.takeTurns(2020)
exampleGame.showLastTurn()

//var testGame1 = Game("1,3,2")
//testGame1.takeTurns(2020)
//testGame1.showLastTurn()
//print("Result should be 1")
//
//var testGame2 = Game("2,1,3")
//testGame2.takeTurns(2020)
//testGame2.showLastTurn()
//print("Result should be 10")
//
//var testGame3 = Game("1,2,3")
//testGame3.takeTurns(2020)
//testGame3.showLastTurn()
//print("Result should be 27")
//
//var testGame4 = Game("2,3,1")
//testGame4.takeTurns(2020)
//testGame4.showLastTurn()
//print("Result should be 78")
//
//var testGame5 = Game("3,2,1")
//testGame5.takeTurns(2020)
//testGame5.showLastTurn()
//print("Result should be 438")
//
//var testGame6 = Game("3,1,2")
//testGame6.takeTurns(2020)
//testGame6.showLastTurn()
//print("Result should be 1836")

let inputStart = "0,13,1,8,6,15"
var inputGame = Game(inputStart, verbose: false)
inputGame.takeTurns(30000000) // 30000000
inputGame.showLastTurn()
