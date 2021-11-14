/// Day 10: Adapter Array

import Foundation

struct JoltageAdapter {
    let outputJoltage: Int
    
    init(_ outputJoltage: Int) {
        self.outputJoltage = outputJoltage
    }
    
    func worksWithInputJoltage(_ sourceJoltage: Int) -> Bool {
        return (outputJoltage - sourceJoltage) <= 3
    }
}

struct JoltageAdapterDifference {
    let oneJolt: Int
    let threeJolt: Int
}

func outputAdapters(_ adapters: [JoltageAdapter]) -> [Int] {
    return adapters.map { $0.outputJoltage }
}

struct Bag {
    let deviceBuiltInJoltage: Int
    let joltageAdapters: [JoltageAdapter]
    
    var joltageAdapterWithStartAndEnd: [JoltageAdapter] {
        get {
            var newJoltageAdapters = [
                JoltageAdapter(0),
                JoltageAdapter(deviceBuiltInJoltage)
            ]
            newJoltageAdapters.insert(contentsOf: joltageAdapters, at: 1)
            return newJoltageAdapters
        }
    }
    
    init(adapterInput: String) {
        let adapterValues = adapterInput.components(separatedBy: "\n").filter { $0 != "" }
        let adapters = adapterValues.map { JoltageAdapter(Int($0)!) }
        let sortedAdaptes = adapters.sorted { $0.outputJoltage < $1.outputJoltage }
        
        self.joltageAdapters = sortedAdaptes
        self.deviceBuiltInJoltage = sortedAdaptes.last!.outputJoltage + 3
    }
    
    func getJoltsDifferences() -> JoltageAdapterDifference {
        var oneJolt = 0
        var threeJolt = 0
        
        for adapterIndex in 0...joltageAdapterWithStartAndEnd.endIndex - 2 {
            let nextAdapterIndex = adapterIndex + 1
            let joltageDifference = joltageAdapterWithStartAndEnd[nextAdapterIndex].outputJoltage - joltageAdapterWithStartAndEnd[adapterIndex].outputJoltage
            
            switch joltageDifference {
            case 1:
                oneJolt += 1
            case 3:
                threeJolt += 1
            default:
                print("WTF")
            }
        }
        
        return JoltageAdapterDifference(oneJolt: oneJolt, threeJolt: threeJolt)
    }
    
    func findAllPossibleArrangements() -> Int {
//        let arrangements = Bag._findAllPossibleAragements(adapterList: joltageAdapterWithStartAndEnd)
//        return arrangements.count
        
        
        /// https://www.reddit.com/r/adventofcode/comments/ka8z8x/comment/gf96lhn/?utm_source=share&utm_medium=web2x&context=3
        
        let startIndex = joltageAdapterWithStartAndEnd.startIndex + 1
        let endIndex = joltageAdapterWithStartAndEnd.endIndex - 2
        
        var listOfCombinations: [Int] = []
        
        var combinationCount: Int = 1
        
        for i in startIndex...endIndex {
            let prevEl = joltageAdapterWithStartAndEnd[i - 1]
            let testEl = joltageAdapterWithStartAndEnd[i]
            let nextEl = joltageAdapterWithStartAndEnd[i + 1]
            
            let canBeRemoved = (testEl.outputJoltage - prevEl.outputJoltage) == 1 && (nextEl.outputJoltage - testEl.outputJoltage) == 1
            
            if (canBeRemoved) {
                if (combinationCount == 1) {
                    combinationCount = 2
                } else if (combinationCount == 2) {
                    combinationCount = 4
                } else if (combinationCount == 4) {
                    combinationCount = 7
                }
            } else {
                listOfCombinations.append(combinationCount)
                combinationCount = 1
            }
            
//            print("\(testEl.outputJoltage) – prev: \(prevEl.outputJoltage) next: \(nextEl.outputJoltage) canberemoved: \(canBeRemoved) c: \(c)")
//            print(l)
        }
        
        return listOfCombinations.reduce(1, *)
    }
    
    /// Works only for max 10 Elements
    static func _findAllPossibleAragements(adapterList: [JoltageAdapter], indent: String = "") -> [[JoltageAdapter]] {
        var adapterList = adapterList
        if (adapterList.count > 1) {
            let testAdapter = adapterList.removeFirst()
            let lastIndex = adapterList.endIndex - 1
//            print(indent, testAdapter.outputJoltage, outputAdapters(adapterList))
            
            var returnAdapterList:[[JoltageAdapter]] = []
            
            for adapterIndex in 0...lastIndex {
                let nextAdapter = adapterList[adapterIndex]
                if (nextAdapter.worksWithInputJoltage(testAdapter.outputJoltage)) {
                    let combinations = Bag._findAllPossibleAragements(
                        adapterList: Array(adapterList[adapterIndex...lastIndex]),
                        indent: indent + "  "
                    )
                    
                    for (var combination) in combinations {
                        combination.insert(testAdapter, at: 0)
                        returnAdapterList.append(combination)
                    }
                }
            }
            
            return returnAdapterList
        } else {
            return [adapterList]
        }
    }
}

let smallExampleInput = """
16
10
15
5
1
11
7
19
6
12
4
"""

let smallExampleBag = Bag(adapterInput: smallExampleInput)
print(outputAdapters(smallExampleBag.joltageAdapterWithStartAndEnd))
let smallExampleJoltsDifference = smallExampleBag.getJoltsDifferences()
print(smallExampleJoltsDifference)
print(smallExampleJoltsDifference.oneJolt * smallExampleJoltsDifference.threeJolt)
let smallExamplePossibleArrangements = smallExampleBag.findAllPossibleArrangements()
print(smallExamplePossibleArrangements)

let largeExampleInput = """
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

let largeExampleBag = Bag(adapterInput: largeExampleInput)
print(largeExampleBag.joltageAdapterWithStartAndEnd.map { $0.outputJoltage })
let largeExampleJoltsDifference = largeExampleBag.getJoltsDifferences()
print(largeExampleJoltsDifference)
print(largeExampleJoltsDifference.oneJolt * largeExampleJoltsDifference.threeJolt)
let largeExamplePossibleArrangements = largeExampleBag.findAllPossibleArrangements()
print(largeExamplePossibleArrangements)

var inputList = Helpers.loadTextdataFromFile(name: "input10")

let inputExampleBag = Bag(adapterInput: inputList)
let inputExampleJoltsDifference = inputExampleBag.getJoltsDifferences()
print(inputExampleJoltsDifference)
print(inputExampleJoltsDifference.oneJolt * inputExampleJoltsDifference.threeJolt)
let inputExamplePossibleArrangements = inputExampleBag.findAllPossibleArrangements()
print(inputExamplePossibleArrangements)
