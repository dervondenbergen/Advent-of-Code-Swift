/// Day 14: Docking Data

import Foundation
import Helpers

struct Program {
    private var mask: String = ""
    private var mem: [Int: UInt] = [:]
    
    private let program: String
    
    init(_ program: String) {
        self.program = program
    }
    
    private func numAsBinary(_ num: UInt, pad: Int = 36) -> String {
        let str = String(num, radix: 2)
        return String(repeatElement("0", count: pad - str.count)) + str
    }

    private func applyMaskToValue(_ value: UInt) -> UInt {
        let andMaskString = mask.replacingOccurrences(of: "X", with: "1")
        let andMask = UInt(andMaskString, radix: 2)!
        let orMaskString  = mask.replacingOccurrences(of: "X", with: "0")
        let orMask = UInt(orMaskString, radix: 2)!
        let output = (value & andMask) | orMask
        return output
    }
    
    mutating func exec() -> Void {
//        print("PROGRAM:\n", program)
        
        let rows = program.components(separatedBy: "\n").filter { $0 != "" }
        
//        print(self)
        
        for row in rows {
            
            let parts = row.components(separatedBy: " = ")
            if (parts[0] == "mask") {
                self.mask = parts[1]
            } else {
                let index = Int(parts[0].prefix(parts[0].count - 1).suffix(parts[0].count - 5))!
                let value = UInt(Int(parts[1])!)
                mem[index] = applyMaskToValue(value)
            }
            
//            print(self)
        }
        
    }
    
    private func addressDecoder(_ value: UInt) -> [UInt] {
        let valueAsBinaryString = numAsBinary(value)
        var maskedValue = String()
        var floatCount = 0
        mask.enumerated().forEach { index, char in
            switch char {
            case "0":
                maskedValue += String(valueAsBinaryString[index])
            default:
                maskedValue += String(char)
                
                if (char == "X") {
                    floatCount += 1
                }
            }
        }
        let options = Int(pow(Double(2), Double(floatCount)))
        let floatPossibilities: [UInt] = (0..<options).map {
            let possibilities = numAsBinary(UInt($0), pad: floatCount).map { $0 }
            var address = maskedValue
            possibilities.forEach {possibility in
                let xIndex = address.firstIndex(of: "X")!
                address.remove(at: xIndex)
                address.insert(possibility, at: xIndex)
            }
            return UInt(address, radix: 2)!
        }
        return floatPossibilities
    }
    
    mutating func execV2() -> Void {
//        print("PROGRAM V2:\n", program)
        
        let rows = program.components(separatedBy: "\n").filter { $0 != "" }
        
//        print(self)
        
        for row in rows {
            
            let parts = row.components(separatedBy: " = ")
            if (parts[0] == "mask") {
                self.mask = parts[1]
            } else {
                let index = UInt(Int(parts[0].prefix(parts[0].count - 1).suffix(parts[0].count - 5))!)
                let value = UInt(Int(parts[1])!)
                
                addressDecoder(index).forEach {
                    mem[Int($0)] = value
                }
            }
            
//            print(self)
        }
    }
    
    func sum() -> UInt {
        return mem.values.reduce(0, +)
    }
}

extension Program: CustomStringConvertible {
    var description: String {
        "Program mit Maske '\(mask)' hat \(mem.count) Werte definiert \n\(mem)"
    }
}

let exampleInput = """
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"""

var exampleProgram = Program(exampleInput)
exampleProgram.exec()
var exampleSum = exampleProgram.sum()
print("sum", exampleSum, "== 165?")

let exampleInputV2 = """
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""

var exampleProgramV2 = Program(exampleInputV2)
exampleProgramV2.execV2()
var exampleSumV2 = exampleProgramV2.sum()
print("sum", exampleSumV2, "== 208?")

var input = Bundle.module.loadTextdataFromFile(name: "input14")
var inputProgram = Program(input)
inputProgram.execV2()
var inputSum = inputProgram.sum()
print("sum", inputSum)
