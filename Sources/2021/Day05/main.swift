/// Day 5: Hydrothermal Venture

import Foundation
import Helpers

struct Ventline {
    // x, y
    let p0: (Int, Int)
    let p1: (Int, Int)
    
    init?(_ lineDecleration: String) {
        let points = lineDecleration.components(separatedBy: " -> ")
        
        let p0Data = points[0].components(separatedBy: ",").map { Int($0)! }
        let p0 = (p0Data[0], p0Data[1])
        
        let p1Data = points[1].components(separatedBy: ",").map { Int($0)! }
        let p1 = (p1Data[0], p1Data[1])
        
//        if (p0.0 != p1.0 && p0.1 != p1.1) {
//            return nil
//        }
        
        self.p0 = p0
        self.p1 = p1
    }
    
    var maxY: Int {
        get {
            return max(p0.1, p1.1)
        }
    }
    var maxX: Int {
        get {
            return max(p0.0, p1.0)
        }
    }
    
    var points: [(Int, Int)] {
        get {
            var list: [(Int, Int)] = []
            
//            list.append(p0)
            
            if (p0.0 == p1.0) {
                // vertical
                
                let direction = p0.1 < p1.1 ? 1 : -1
                stride(from: p0.1, through: p1.1, by: direction).forEach {
                    list.append((p0.0, $0))
                }
            }
            if (p0.1 == p1.1) {
                // horizontal
                
                let direction = p0.0 < p1.0 ? 1 : -1
                stride(from: p0.0, through: p1.0, by: direction).forEach {
                    list.append(($0, p0.1))
                }
            }
            if (p0.0 != p1.0 && p0.1 != p1.1) {
                // diagonal
                
                let directionX = p0.0 < p1.0 ? 1 : -1
                let stepsX = stride(from: p0.0, through: p1.0, by: directionX).map { Int(exactly: $0)! }
                
                let directionY = p0.1 < p1.1 ? 1 : -1
                let stepsY = stride(from: p0.1, through: p1.1, by: directionY).map { Int(exactly: $0)! }
                                
                stepsX.enumerated().forEach { index, valueX in
                    let valueY = stepsY[index]
                    list.append((valueX, valueY))
                }
            }
            
            
            return list
        }
    }
}

extension Ventline: CustomStringConvertible {
    var description: String {
        "Ventline \(points)"
    }
}

struct VentAvoidenceSystem {
    let vents: [Ventline]
    var diagram: [[Int]]
    
    init(vents: String) {
        self.vents = vents
            .components(separatedBy: "\n")
            .filter { $0 != "" }
            .map { Ventline($0) }
            .filter { $0 != nil }
            .map { $0! }
        
        let maxY = self.vents.map { $0.maxY }.max()! // amount of rows
        let maxX = self.vents.map { $0.maxX }.max()! // amount of columns (inside of rows)
                
        self.diagram = [[Int]](repeating: [Int](repeating: 0, count: maxX + 1), count: maxY + 1)
    }
    
    mutating func drawVentlines() -> Void {
        for vent in vents {
            for point in vent.points {
                self.diagram[point.1][point.0] += 1
            }
        }
    }
    
    func countDangerousAreas() -> Int {
        return diagram.flatMap { $0 }.filter { $0 > 1 }.count
    }
    
    func printDiagram() -> Void {
        let visibleDiagram = self.diagram
            .map {
                $0.map {
                    return $0 == 0 ? "." : String($0)
                }.joined(separator: "")
            }
            .joined(separator: "\n")
        
        print(visibleDiagram)
    }
}

let exampleVents = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""

var exampleSystem = VentAvoidenceSystem(vents: exampleVents)

exampleSystem.drawVentlines()
print(exampleSystem.countDangerousAreas())

let inputVents = Bundle.module.loadTextdataFromFile(name: "input05")

var inputSystem = VentAvoidenceSystem(vents: inputVents)
inputSystem.drawVentlines()
print(inputSystem.countDangerousAreas())
