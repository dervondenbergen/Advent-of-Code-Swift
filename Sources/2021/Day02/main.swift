/// Day 2: Dive!

import Foundation
import Helpers

struct Submarine {
    var horizontalPosition = 0
    var depth = 0
    
    let commands: String
    
    init(_ commands: String) {
        self.commands = commands
    }
    
    mutating func takeCourse() -> Void {
        let cmds = commands.components(separatedBy: "\n").filter { $0 != "" }
        
        cmds.forEach { command in
            let parts = command.components(separatedBy: " ")
            
            let task = parts[0]
            let value = Int(parts[1])!
            
            switch task {
            case "forward":
                horizontalPosition += value
            case "down":
                depth += value
            case "up":
                depth -= value
            default:
                break
            }
        }
    }
    
    mutating func takeCourseCorrect() -> Void {
        let cmds = commands.components(separatedBy: "\n").filter { $0 != "" }
        var aim = 0
        
        cmds.forEach { command in
            let parts = command.components(separatedBy: " ")
            
            let task = parts[0]
            let value = Int(parts[1])!
            
            switch task {
            case "forward":
                horizontalPosition += value
                depth += aim * value
            case "down":
                aim += value
            case "up":
                aim -= value
            default:
                break
            }
        }
    }
}

extension Submarine: CustomStringConvertible {
    var description: String {
        "Submarine has horizontal position of \(horizontalPosition) and depth of \(depth), resulting in \(horizontalPosition * depth)."
    }
}

let exampleCommands = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""

var exampleSubmarine = Submarine(exampleCommands)
exampleSubmarine.takeCourseCorrect()
print(exampleSubmarine)

let inputCommands = Bundle.module.loadTextdataFromFile(name: "input02")
var inputSubmarine = Submarine(inputCommands)
inputSubmarine.takeCourseCorrect()
print(inputSubmarine)
