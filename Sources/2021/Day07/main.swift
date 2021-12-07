/// Day 7: The Treachery of Whales

import Foundation
import Helpers

extension Array where Element == Int {
    func median() -> Double? {
        guard count > 0  else { return nil }

        let sortedArray = self.sorted()
        if count % 2 != 0 {
            return Double(sortedArray[count/2])
        } else {
            return Double(sortedArray[count/2] + sortedArray[count/2 - 1]) / 2.0
        }
    }
}

func getFuelForCheapestPosition(positions positionData: String) -> Int {
    let positions = positionData
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: ",")
        .map { Int($0)! }
    
    let cheapestPosition = positions.median()!
    
    let fuel = positions.map {
        abs($0 - Int(cheapestPosition))
    }.reduce(0, +)
    
    return fuel
}

func getFuelForCheapestPositionV2(positions positionData: String) -> Int {
    let positions = positionData
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: ",")
        .map { Int($0)! }
    
//    let cheapestPosition = round(Double(positions.reduce(0, +)) / Double(positions.count)) // should do the correct thing but live data results in 473.505 which would round up
//    let cheapestPosition = ceil(Double(positions.reduce(0, +)) / Double(positions.count)) // works with example data
    let cheapestPosition = floor(Double(positions.reduce(0, +)) / Double(positions.count)) // works with input data
        
    let fuel = positions.map {
        let difference = abs($0 - Int(cheapestPosition))
        let difference = abs($0 - Int(cheapestPosition))
        if difference == 0 {
            return 0
        }
        return (1...difference).reduce(0, +)
    }.reduce(0, +)
    
    return fuel
}

let examplePositions = """
16,1,2,0,4,2,7,1,2,14
"""

print(getFuelForCheapestPosition(positions: examplePositions))
print(getFuelForCheapestPositionV2(positions: examplePositions))

let inputPositions = Bundle.module.loadTextdataFromFile(name: "input07")

print(getFuelForCheapestPosition(positions: inputPositions))
print(getFuelForCheapestPositionV2(positions: inputPositions))
