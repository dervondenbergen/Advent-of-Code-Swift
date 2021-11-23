/// Day 3: Toboggan Trajectory

import Foundation
import Helpers

let exampleSlope = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""

let numberSlope = """
1234
5678
abcd
efgh
ijkl
mnop
qrst
uvwx
ylz!
"""

let content = Bundle.module.loadTextdataFromFile(name: "input03")

let inputSlope = content

func getSlopeValueAt(rowPosition: Int, columnPosition: Int, slope: String) -> Character {
    let rows = slope.split(separator: "\n")
    let row = rows[rowPosition - 1]
    
    let columnCount = row.count
    let column = Array(row)
    let columnIndex = column.index(0, offsetBy: (columnPosition - 1) % columnCount)
    
    return column[columnIndex]
}

func getTreeAmount(slope: String, addRow: Int, addColumn: Int) -> Int {
    let rowCount = slope.split(separator: "\n").count
    
    var currentRow = 1;
    var currentColumn = 1;

    var openSpaces = 0;
    var treeSpaces = 0;

    for _ in 1...rowCount {
        currentRow = currentRow + addRow
        currentColumn = currentColumn + addColumn
        
        if (currentRow <= rowCount) {
        
            let value = getSlopeValueAt(rowPosition: currentRow, columnPosition: currentColumn, slope: slope)

            if (value == ".") {
                openSpaces += 1
//                print("\(i): open")
            }
            if (value == "#") {
                treeSpaces += 1
//                print("\(i): tree")
            }
            
        }
    }

//    print("Open amount: \(openSpaces)")
//    print("Tree amount: \(treeSpaces)")
    
    return treeSpaces
}

struct Way {
    let addColumn: Int
    let addRow: Int
}

let ways = [
    Way(addColumn: 1, addRow: 1),
    Way(addColumn: 3, addRow: 1),
    Way(addColumn: 5, addRow: 1),
    Way(addColumn: 7, addRow: 1),
    Way(addColumn: 1, addRow: 2),
]

let trees = ways.map({ way in
    return getTreeAmount(slope: inputSlope, addRow: way.addRow, addColumn: way.addColumn)
})

print(trees.reduce(1, *))
