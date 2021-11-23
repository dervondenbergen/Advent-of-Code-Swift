/// Day 12: Rain Risk

import Foundation
import Helpers

enum Direction: String {
    case east  = "E"
    case north = "N"
    case west  = "W"
    case south = "S"
}

enum Move: String {
    case forward = "F"
    case left = "L"
    case right = "R"
}

enum Action {
    case direction(dir: Direction, value: Int)
    case move(mov: Move, value: Int)
}

extension Action {
    static func from(_ instruction: String) -> Action? {
        let action = String(Array(instruction)[0])
        let value = Int(String(Array(instruction)[1...]))!
        
        if let mov = Move(rawValue: action) {
            return Action.move(mov: mov, value: value)
        }
        
        if let dir = Direction(rawValue: action) {
            return Action.direction(dir: dir, value: value)
        }
        
        return nil
    }
}

struct Ship {
    private var direction: Direction
    
    private var eastWestPosition: Int
    private var northSouthPosition: Int
    
    private var shipPositionEastWest: Int = 0
    private var shipPositionNorthSouth: Int = 0
    
    private let actions: [Action]
    private let originalInstructions: String
    
    init(
        _ instructions: String,
        startDirection: Direction = .east,
        startEastWestPosition: Int = 0,
        startNorthSouthPosition: Int = 0
    ) {
        self.originalInstructions = instructions
        self.actions = instructions
            .components(separatedBy: "\n")
            .filter { $0 != "" }
            .map { Action.from($0)! }
        
        self.direction = startDirection
        
        self.eastWestPosition = startEastWestPosition
        self.northSouthPosition = startNorthSouthPosition
    }
    
    mutating func move() -> Void {
        actions.forEach { action in
            switch action {
            case .direction(let dir, let value):
                
                goDirection(dir, value)
                
            case .move(let mov, let value):
                
                switch mov {
                case .forward:
                    goDirection(self.direction, value)
                case .right:
                    turnDirection(value)
                case .left:
                    turnDirection(value * -1)
                }
                
            }
        }
    }
    
    mutating func goDirection(_ direction: Direction, _ value: Int) -> Void {
        switch direction {
        case .east:
            self.eastWestPosition += value
        case .west:
            self.eastWestPosition -= value
        case .north:
            self.northSouthPosition += value
        case .south:
            self.northSouthPosition -= value
        }
    }
    
    mutating func turnDirection(_ degrees: Int) -> Void {
        let order: [Direction] = [.east, .south, .west, .north]
        let currentDirectionIndex = order.firstIndex(of: self.direction)!
        let steps = degrees / 90
        var newDirectionIndex = (currentDirectionIndex + steps) % 4
        if (newDirectionIndex < 0) {
            newDirectionIndex = 4 + newDirectionIndex
        }
        self.direction = order[newDirectionIndex]
    }
    
    func manhattanDistance() -> Int {
        return abs(eastWestPosition) + abs(northSouthPosition)
    }
}

typealias ActualShip = Ship

extension ActualShip {
    
    mutating func actualMove() -> Void {        
        actions.forEach { action in
            switch action {
            case .direction(let dir, let value):
                
                actualGoDirection(dir, value)
                
            case .move(let mov, let value):
                
                switch mov {
                case .forward:
                    shipPositionEastWest += eastWestPosition * value
                    shipPositionNorthSouth += northSouthPosition * value
                case .right:
                    actualTurnDirection(value)
                case .left:
                    actualTurnDirection(value * -1)
                }
                
            }
        }
    }
    
    mutating func actualGoDirection(_ direction: Direction, _ value: Int) -> Void {
        switch direction {
        case .east:
            self.eastWestPosition += value
        case .west:
            self.eastWestPosition -= value
        case .north:
            self.northSouthPosition += value
        case .south:
            self.northSouthPosition -= value
        }
    }
    
    mutating func actualTurnDirection(_ degrees: Int) -> Void {
        let order: [Direction] = [.east, .south, .west, .north]
        let currentDirectionIndex = order.firstIndex(of: self.direction)!
        let steps = degrees / 90
        var newDirectionIndex = (currentDirectionIndex + steps) % 4
        if (newDirectionIndex < 0) {
            newDirectionIndex = 4 + newDirectionIndex
        }
        self.direction = order[newDirectionIndex]
        var turns = steps % 4
        if (turns < 0) {
            turns = 4 + turns
        }
        switch turns {
        case 1:
            swap(&eastWestPosition, &northSouthPosition)
            northSouthPosition *= -1
        case 2:
            northSouthPosition *= -1
            eastWestPosition *= -1
        case 3:
            swap(&eastWestPosition, &northSouthPosition)
            eastWestPosition *= -1
        default: break
        }
    }
    
    func actualManhattanDistance() -> Int {
        return abs(shipPositionEastWest) + abs(shipPositionNorthSouth)
    }
}

let exampleInstructions = """
F10
N3
F7
R90
F11
"""

var exampleShip = Ship(exampleInstructions)

exampleShip.move()
print(exampleShip.manhattanDistance())

var actualExampleShip = ActualShip(
    exampleInstructions,
    startDirection: .east,
    startEastWestPosition: 10,
    startNorthSouthPosition: 1
)

actualExampleShip.actualMove()
print(actualExampleShip.actualManhattanDistance())

var inputInstructions = Bundle.module.loadTextdataFromFile(name: "input12")

var inputShip = Ship(inputInstructions)

inputShip.move()
print(inputShip.manhattanDistance())

var actualInputShip = ActualShip(
    inputInstructions,
    startDirection: .east,
    startEastWestPosition: 10,
    startNorthSouthPosition: 1
)

actualInputShip.actualMove()
print(actualInputShip.actualManhattanDistance())
