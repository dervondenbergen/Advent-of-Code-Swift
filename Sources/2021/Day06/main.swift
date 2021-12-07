/// Day 6: Lanternfish

import Foundation
import Helpers

struct Swarm {
    var fish: [Int]
    var day = 0
    
    init(nearbyFishInfo: String) {
        self.fish = nearbyFishInfo
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .filter { $0 != "" }
            .map { Int($0)! }
        
        print(fish)
    }
    
    mutating func increaseDay() -> Void {
        var newFish: [Int] = []
        fish = fish.map {
            if ($0 == 0) {
                newFish.append(8)
                return 6
            } else {
                return $0 - 1
            }
        }
        
        fish += newFish
        
        day += 1
    }
}

extension Swarm: CustomStringConvertible {
    var description: String {
        let fishString = fish.map { String($0) }.joined(separator: ",")
        
        return "Fischies \(fishString)"
    }
}

let exampleInfo = """
3,4,3,1,2

"""

var exampleSwarm = Swarm(nearbyFishInfo: exampleInfo)
for _ in 0..<80 {
    exampleSwarm.increaseDay()
}
print(exampleSwarm.fish.count)

let inputInfo = Bundle.module.loadTextdataFromFile(name: "input06")

var inputSwarm = Swarm(nearbyFishInfo: inputInfo)
for _ in 0..<80 {
    inputSwarm.increaseDay()
}
print(inputSwarm.fish.count)
