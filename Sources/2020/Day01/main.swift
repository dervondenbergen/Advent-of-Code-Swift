/// Day 1: Report Repair

import Foundation
import Helpers

let combinedValue = 2020

let exampleData: [Int] = [
    1721,
    979,
    366,
    299,
    675,
    1456,
]

let content = Bundle.module.loadTextdataFromFile(name: "input01")

let inputData = content.split(separator: "\n").map { string -> Int in
    return Int(string)!
}

func findPair(from list: [Int], resulting combinedValue: Int) -> [Int] {
    for (index1, item1) in list.enumerated() {
        for (index2, item2) in list.enumerated() {
            if index1 != index2 {
                if (item1 + item2) == combinedValue {
                    return [
                        item1,
                        item2,
                    ]
                }
            }
        }
    }
    
    return []
}

let pair = findPair(from: inputData, resulting: combinedValue)

if pair.count == 2 {
    let item1 = pair[0]
    let item2 = pair[1]
    
    let multiplication = item1 * item2
    
    print("pair: \(pair) resulting in \(multiplication)")
}

func findThreir(from list: [Int], resulting combinedValue: Int) -> [Int] {
    for (index1, item1) in list.enumerated() {
        for (index2, item2) in list.enumerated() {
            for (index3, item3) in list.enumerated() {
                if index1 != index2 && index1 != index3 && index2 != index3 {
                    if (item1 + item2 + item3) == combinedValue {
                        return [
                            item1,
                            item2,
                            item3,
                        ]
                    }
                }
            }
        }
    }
    
    return []
}

let threir = findThreir(from: inputData, resulting: combinedValue)

if threir.count == 3 {
    let item1 = threir[0]
    let item2 = threir[1]
    let item3 = threir[2]

    let multiplication = item1 * item2 * item3

    print("threir: \(threir) resulting in \(multiplication)")
}

func findElements(where number: Int, from list: [Int], resultIn combinedValue: Int) -> [Int] {
    if (number == 0) {
        return list
    }
    
    for (index, item) in list.enumerated() {
        let rest = combinedValue - item;
        
        if (rest == 0) {
            return [item]
        }
        
        if (rest < 0) {
            continue
        }
                
        var newlist = list
        newlist.remove(at: index)
        
        let possibleRest = findElements(where: number - 1, from: newlist, resultIn: rest)
                
        if rest == possibleRest.reduce(0, +) {
            var newitems = possibleRest
            newitems.append(item)
            return newitems
        }
    }
    
    return []
}

func multiplyElements(_ list: [Int]) -> Int {
    return list.reduce(1, *)
}

let twoElements = findElements(where: 2, from: inputData, resultIn: combinedValue)
let threeElements = findElements(where: 3, from: inputData, resultIn: combinedValue)

print("two elements: \(twoElements) resulting in \(multiplyElements(twoElements))")
print("three elements: \(threeElements) resulting in \(multiplyElements(threeElements))")

print("\nTEST\n")

let t2E = findElements(where: 2, from: exampleData, resultIn: combinedValue)
let mEt2E = multiplyElements(t2E)
print("test two: \(t2E) resulting in \(mEt2E) should equal 514579 == \(mEt2E == 514579)")
let t3E = findElements(where: 3, from: exampleData, resultIn: combinedValue)
let mEt3E = multiplyElements(t3E)
print("test three: \(t3E) resulting in \(mEt3E) should equal 241861950 == \(mEt3E == 241861950)")
/// OHJE geht eigentlich gar nicht, weil returned schon auch wenn nur zwei den wert erreichen
