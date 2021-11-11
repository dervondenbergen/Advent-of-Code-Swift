/// Day 9: Encoding Error

import Foundation

struct InvalidNumber {
    let value: Int
    let index: Int
}

struct XmasCracker {
    let numberSeries: [Int]
    let preambleLength: Int
    
    init(numberSeries: String, preambleLength: Int = 25) {
        self.numberSeries = numberSeries.components(separatedBy: "\n").filter { $0 != "" }.map { Int($0)! }
        self.preambleLength = preambleLength
    }
    
    func findInvalidNumber () -> InvalidNumber? {
        for elementIndex in preambleLength...numberSeries.endIndex - 1 {
            let searchListStart = elementIndex - preambleLength
            let searchList = Array(numberSeries.suffix(from: searchListStart).prefix(preambleLength))
            
            let possibleResult = numberSeries[elementIndex]
            let canBeCalculatedFromTwoItems = XmasCracker.canCalculateResultFrom(
                list: searchList,
                result: possibleResult
            ).count == 2

            if (!canBeCalculatedFromTwoItems) {
                return InvalidNumber(value: possibleResult, index: elementIndex)
            }
        }
        
        return nil
    }
    
    func findEncryptionWeakness () -> Int? {
        let invalidNumber = findInvalidNumber()
        if (invalidNumber == nil) {
            return nil
        }
        
        let possibleResult = invalidNumber!.value
        
        let possibleElements = numberSeries.prefix(invalidNumber!.index)
        let lastIndex = possibleElements.endIndex - 1
        
        var contiguousListOfNumbersResultingInResult: [Int] = []
        
        allElementsLoop: for elementIndex in 0...lastIndex {
            let element = possibleElements[elementIndex]
            
            // element can only be part of addition if it is smaller than result
            if (element < possibleResult) {
                contiguousListLoop: for indexFromElementIndex in elementIndex...lastIndex {
                    let possibleContigousList = possibleElements.suffix(from: elementIndex).prefix(upTo: indexFromElementIndex + 1)
                    let sumOfPossibleContigousList = possibleContigousList.reduce(0, +)
                    
                    if (sumOfPossibleContigousList > possibleResult) {
                        // contigousList can't grow further, as it is alrady larger than result
                        break contiguousListLoop
                    }
                    
                    if (sumOfPossibleContigousList == possibleResult) {
                        contiguousListOfNumbersResultingInResult = Array(possibleContigousList)
                        break allElementsLoop
                    }
                }
            }
        }
        
        if (!contiguousListOfNumbersResultingInResult.isEmpty) {
            let elementsResultingInResult = contiguousListOfNumbersResultingInResult.sorted()
            
            let encryptionWeakness = elementsResultingInResult.first! + elementsResultingInResult.last!
            
            return encryptionWeakness
        } else {
            return nil
        }
    }
    
    static func canCalculateResultFrom(list: [Int], result: Int) -> [Int] {
        let smallerThanResult = list.filter { $0 < result }
        for number1 in smallerThanResult {
            for number2 in smallerThanResult {
                if (number1 == number2) {
                    continue
                }
                if (number1 + number2 == result) {
                    return [number1, number2]
                }
            }
        }
        return []
    }
}


let exampleList = """
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""

let exampleCrack = XmasCracker(numberSeries: exampleList, preambleLength: 5)

let exampleInvalid = exampleCrack.findInvalidNumber()
print("Example Invalid Number: \(exampleInvalid != nil ? String(exampleInvalid!.value) : "none")")

let exampleWeakness = exampleCrack.findEncryptionWeakness()
print("Example Weakness: \(exampleWeakness != nil ? String(exampleWeakness!) : "none")")


var inputList = Helpers.loadTextdataFromFile(name: "input09")
var inputCrack = XmasCracker(numberSeries: inputList)

var inputInvalid = inputCrack.findInvalidNumber()
print("Input Invalid Number: \(inputInvalid != nil ? String(inputInvalid!.value) : "none")")

let inputWeakness = inputCrack.findEncryptionWeakness()
print("Input Weakness: \(inputWeakness != nil ? String(inputWeakness!) : "none")")
