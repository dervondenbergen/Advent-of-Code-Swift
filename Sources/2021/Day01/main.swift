/// Day 1: Sonar Sweep

import Foundation
import Helpers

struct SonarMeasurements {
    private let measurements: [Int]
    
    init(_ rawMeasurements: String) {
        measurements = rawMeasurements.components(separatedBy: "\n").filter { $0 != "" }.map { Int($0)! }
    }
    
    func findNumberOfIncreases() -> Int {
        var lastMeasurement = measurements.first!
        var increases = 0
        
        measurements.forEach {
            if ($0 > lastMeasurement) {
                increases += 1
            }
            lastMeasurement = $0
        }
        
        return increases
    }
    
    func findNumberOfIncreasesInDoors() -> Int {
        var lastSum = measurements[0...2].reduce(0, +)
        var increases = 0
        
        for i in 0...(measurements.endIndex - 3) {
            let sum = measurements[i...(i+2)].reduce(0, +)
            if (sum > lastSum) {
                increases += 1
            }
            lastSum = sum
        }
        
        return increases
    }
}

let exampleMeasurements = """
199
200
208
210
200
207
240
269
260
263
"""

let example = SonarMeasurements(exampleMeasurements)
print(example.findNumberOfIncreases())
print(example.findNumberOfIncreasesInDoors())

let inputMeasurements = Bundle.module.loadTextdataFromFile(name: "input01")
let input = SonarMeasurements(inputMeasurements)
print(input.findNumberOfIncreases())
print(input.findNumberOfIncreasesInDoors())
