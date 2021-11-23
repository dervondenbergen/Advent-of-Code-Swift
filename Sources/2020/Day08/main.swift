//: [Previous](@previous)

import Foundation
import Regex
import Helpers

let exampleProgramm = """
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

enum Operation: String {
    case acc, jmp, nop
}

struct Instruction {
    var operation: Operation
    var argument: Int
}

extension Instruction: CustomStringConvertible {
    var description: String {
        get {
            let prefix = argument >= 0 ? "+" : ""
            return "\(operation) \(prefix)\(argument)"
        }
    }
}

typealias InstructionSetIndex = Array<Any>.Index

struct Execution {
    var accumulator = 0
    var executedInsturctions: Set<InstructionSetIndex> = Set([])
    var executedWithoutCrash = true
}

struct InstructionSet {
    let originalProgramm: String
    var instructions: [Instruction]
    
    init(programm: String) {
        let instructionRegex = Regex(#"(?<op>\w{3}) (?<arg>.\d+)"#)
        let programmInstructions = programm.components(separatedBy: "\n").filter { $0 != "" }
        
        instructions = programmInstructions.map {
            let instructionMatch = instructionRegex.firstMatch(in: $0)!
            
            let operationValue = instructionMatch.group(named: "op")!.value
            let argumentValue = instructionMatch.group(named: "arg")!.value
            
            return Instruction(
                operation: Operation(rawValue: operationValue)!,
                argument: Int(argumentValue)!
            )
        }
        
        originalProgramm = programm
    }
    
    func execute() -> Execution {
        var executingIndex: InstructionSetIndex = 0
        let lastIndex: InstructionSetIndex = instructions.endIndex
        var continueExecution = true
        
        var execution = Execution()
        
        while continueExecution {
            let insertion = execution.executedInsturctions.insert(executingIndex)
            
            if (!insertion.inserted) {
                continueExecution = false
                execution.executedWithoutCrash = false
                
                break
            }
            
            let instruction = instructions[executingIndex]
            
            switch instruction.operation {
            case .acc:
                executingIndex += 1
                execution.accumulator += instruction.argument
                
            case .jmp:
                executingIndex += instruction.argument
                
            case .nop:
                executingIndex += 1
            }
            
            if (executingIndex == lastIndex) {
                continueExecution = false
            }
        }
        
        return execution
    }
    
    func generateWorkingInstructionSet() -> InstructionSet {
        let jmpOrNopOperations:Set<Operation> = Set([.jmp, .nop])
        var jmpOrNopInstructions:[InstructionSetIndex:Instruction] = [:]
        
        self.instructions.enumerated().forEach { index, instruction in
            if jmpOrNopOperations.contains(instruction.operation) {
                jmpOrNopInstructions.updateValue(instruction, forKey: index)
            }
        }
        
        for instruction in jmpOrNopInstructions {
            var testInstructionSet = self
            
            var testInstructionOperation = instruction.value.operation
            if (testInstructionOperation == .nop) {
                testInstructionOperation = .jmp
            }
            if (testInstructionOperation == .jmp) {
                testInstructionOperation = .nop
            }
            testInstructionSet.instructions[instruction.key].operation = testInstructionOperation
            
            let testExecution = testInstructionSet.execute()
            
            if (testExecution.executedWithoutCrash) {
                return testInstructionSet
            }
        }
        
        return self
    }
}

extension InstructionSet: CustomStringConvertible {
    var description: String {
        get {
            return instructions.enumerated().map { index, instruction in
                return "\(index). \(instruction)"
            } .joined(separator: "\n")
        }
    }
}

var exampleInsturctionSet = InstructionSet(programm: exampleProgramm)
var exampleExecution = exampleInsturctionSet.execute()
print("Example Program (Broken)  - Accumulation from Instructions: \(exampleExecution.accumulator) (Ended without Problems '\(exampleExecution.executedWithoutCrash)')")

var workingExampleInstructionSet = exampleInsturctionSet.generateWorkingInstructionSet()
var workingExampleExecution = workingExampleInstructionSet.execute()
print("Example Program (Working) - Accumulation from Instructions: \(workingExampleExecution.accumulator) (Ended without Problems '\(workingExampleExecution.executedWithoutCrash)')")

var inputProgramm = Bundle.module.loadTextdataFromFile(name: "input08")
var inputInsturctionSet = InstructionSet(programm: inputProgramm)
var inputExecution = inputInsturctionSet.execute()
print("Input Program (Broken)  - Accumulation from Instructions: \(inputExecution.accumulator) (Ended without Problems '\(inputExecution.executedWithoutCrash)')")

var workingInputInstructionSet = inputInsturctionSet.generateWorkingInstructionSet()
var workingInputExecution = workingInputInstructionSet.execute()
print("Input Program (Working) - Accumulation from Instructions: \(workingInputExecution.accumulator) (Ended without Problems '\(workingInputExecution.executedWithoutCrash)')")
