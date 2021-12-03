/// Day 3: Binary Diagnostic

import Foundation
import Helpers

struct Diagnostics {
    let report: String
    let reportNumbers: [Int]
    let binaryLength: Int
    
    init(_ reportData: String) {
        self.report = reportData
        
        let reportNumbersStrings = report.components(separatedBy: "\n").filter { $0 != "" }
        
        self.reportNumbers = reportNumbersStrings.map { Int($0, radix: 2)! }
        
        self.binaryLength = reportNumbersStrings.first!.count
    }
    
    lazy var bitCount: [(Int, Int)] = {
        var bitCount = [(Int, Int)](repeating: (0, 0), count: binaryLength)
        
        for number in reportNumbers {
            for (index, mask) in (0..<binaryLength).reversed().enumerated() {
                let maskValue = 2.pow(to: mask)
                
                if (number & maskValue) > 0 {
                    bitCount[index].1 += 1
                } else {
                    bitCount[index].0 += 1
                }
                
            }
        }
        
        return bitCount
    }()
    
    lazy var gammaRate: Int = {
        var newBinaryNumber = ""
        for bitNumber in bitCount {
            if (bitNumber.0 > bitNumber.1) {
                newBinaryNumber += "0"
            } else {
                newBinaryNumber += "1"
            }
        }
        return Int(newBinaryNumber, radix: 2)!
    }()
    
    lazy var epsilonRate: Int = {
        var newBinaryNumber = ""
        for bitNumber in bitCount {
            if (bitNumber.0 < bitNumber.1) {
                newBinaryNumber += "0"
            } else {
                newBinaryNumber += "1"
            }
        }
        return Int(newBinaryNumber, radix: 2)!
    }()
    
    lazy var powerConsumption: Int = {
        return gammaRate * epsilonRate
    }()
    
    lazy var oxygenGeneratorRating: Int = {
        var filteredNumbers = reportNumbers
        
        for (index, mask) in (0..<binaryLength).reversed().enumerated() {
            let maskValue = 2.pow(to: mask)
            filteredNumbers = filterNumbers(from: filteredNumbers, conforming: maskValue, being: .one)
            if (filteredNumbers.count == 1) {
                break
            }
        }
        
        return filteredNumbers.first!
    }()
    
    lazy var co2ScrubberRating: Int = {
        var filteredNumbers = reportNumbers
        
        for (index, mask) in (0..<binaryLength).reversed().enumerated() {
            let maskValue = 2.pow(to: mask)
            filteredNumbers = filterNumbers(from: filteredNumbers, conforming: maskValue, being: .zero)
            if (filteredNumbers.count == 1) {
                break
            }
        }
        
        return filteredNumbers.first!
    }()
    
    lazy var lifeSupportRating: Int = {
        return oxygenGeneratorRating * co2ScrubberRating
    }()
    
    private enum ZeroOne {
        case zero
        case one
    }
    
    private enum CountState {
        case moreZero
        case moreOne
        case equal
    }
        
    private func filterNumbers(from numberArray: [Int], conforming maskValue: Int, being: ZeroOne) -> [Int] {
        var bitCount: ([Int], [Int]) = ([], [])

        for number in numberArray {
            if (number & maskValue) > 0 {
                bitCount.1.append(number)
            } else {
                bitCount.0.append(number)
            }
        }
        
        var countState: CountState = .equal
        if (bitCount.0.count > bitCount.1.count) {
            countState = .moreZero
        } else if (bitCount.0.count < bitCount.1.count) {
            countState = .moreOne
        }
        
        switch (being, countState) {
        case (.one, .moreOne):
            return bitCount.1
        case (.one, .moreZero):
            return bitCount.0
        case (.one, .equal):
            return bitCount.1
        case (.zero, .moreOne):
            return bitCount.0
        case (.zero, .moreZero):
            return bitCount.1
        case (.zero, .equal):
            return bitCount.0
        }

    }
}

let exapmleReportData = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""
var exampleReport = Diagnostics(exapmleReportData)

print(exampleReport.gammaRate)
print(exampleReport.epsilonRate)
print(exampleReport.powerConsumption)

print(exampleReport.oxygenGeneratorRating)
print(exampleReport.co2ScrubberRating)
print(exampleReport.lifeSupportRating)

let inputReportData = Bundle.module.loadTextdataFromFile(name: "input03")
var inputReport = Diagnostics(inputReportData)

print(inputReport.powerConsumption)
print(inputReport.lifeSupportRating)
