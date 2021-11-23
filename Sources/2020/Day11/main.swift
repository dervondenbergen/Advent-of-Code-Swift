/// Day 11: Seating System

import Foundation
import Helpers

struct Matrix<T> {
    let rows: Int, columns: Int
    var grid: [T]
    init(rows: Int, columns: Int, defaultValue: T) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: defaultValue, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

extension Matrix: CustomStringConvertible {
    var description: String {
        var output = ""
        for r in 0 ..< rows {
            for c in 0 ..< columns {
                output += "\(self[r, c])"
            }
            output += "\n"
        }
        return output
    }
}

extension Matrix: Hashable {
    static func == (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
        lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rows)
        hasher.combine(columns)
        hasher.combine(description)
    }
}

extension Matrix {
    func getAdjacentElements(row: Int, column: Int) -> [T] {
        let adjacentRows = (row - 1...row + 1).filter { $0 >= 0 && $0 < rows }
        let adjacentColumns = (column - 1...column + 1).filter { $0 >= 0 && $0 < columns }
        
        var adjacentElements:[T] = []
        
        for r in adjacentRows {
            for c in adjacentColumns {
                if (row == r && column == c) {
                    continue
                }
                
                adjacentElements.append(self[r, c])
            }
        }
        // maybe something like this could work, but means more uneccesary work
        // https://stackoverflow.com/questions/25109161/swift-array-slicing-with-a-range-in-the-subscript
        
        return adjacentElements
    }
    
    struct DirectionalElements {
        var left: [T] = []
        var topLeft: [T] = []
        var top: [T] = []
        var topRight: [T] = []
        var right: [T] = []
        var bottomRight: [T] = []
        var bottom: [T] = []
        var bottomLeft: [T] = []
        
        func getAdjacentElements (_ isIncluded: (T) -> Bool) -> [T] {
            var adjacentElements:[T?] = []
            
            adjacentElements.append(left.first(where: { isIncluded($0) } ) ?? nil)
            adjacentElements.append(topLeft.first(where: { isIncluded($0) } ) ?? nil)
            adjacentElements.append(top.first(where: { isIncluded($0) } ) ?? nil)
            adjacentElements.append(topRight.first(where: { isIncluded($0) } ) ?? nil)
            adjacentElements.append(right.first(where: { isIncluded($0) } ) ?? nil)
            adjacentElements.append(bottomRight.first(where: { isIncluded($0) } ) ?? nil)
            adjacentElements.append(bottom.first(where: { isIncluded($0) } ) ?? nil)
            adjacentElements.append(bottomLeft.first(where: { isIncluded($0) } ) ?? nil)
            
            return adjacentElements.filter { $0 != nil } as! [T]
        }
    }

    struct Index {
        let row: Int
        let column: Int

        init(_ row: Int, _ column: Int) {
            self.row = row
            self.column = column
        }
    }

    func indexIsValid(_ index: Index) -> Bool {
        return indexIsValid(row: index.row, column: index.column)
    }
    subscript(index: Index) -> T {
        return self[index.row, index.column]
    }
    
    func getDirectionalElements(row: Int, column: Int) -> DirectionalElements {
        
//        print("start", row, column)
        var directionalElements = DirectionalElements()
        
        for i in 1...max(rows, columns) {
            let left =        Index(row    , column - i);
            let topLeft =     Index(row - i, column - i);
            let top =         Index(row - i, column    );
            let topRight =    Index(row - i, column + i);
            let right =       Index(row    , column + i);
            let bottomRight = Index(row + i, column + i);
            let bottom =      Index(row + i, column    );
            let bottomLeft =  Index(row + i, column - i);
            
            if (indexIsValid(left)) {
                directionalElements.left.append(self[left])
            }
            if (indexIsValid(topLeft)) {
                directionalElements.topLeft.append(self[topLeft])
            }
            if (indexIsValid(top)) {
                directionalElements.top.append(self[top])
            }
            if (indexIsValid(topRight)) {
                directionalElements.topRight.append(self[topRight])
            }
            if (indexIsValid(right)) {
                directionalElements.right.append(self[right])
            }
            if (indexIsValid(bottomRight)) {
                directionalElements.bottomRight.append(self[bottomRight])
            }
            if (indexIsValid(bottom)) {
                directionalElements.bottom.append(self[bottom])
            }
            if (indexIsValid(bottomLeft)) {
                directionalElements.bottomLeft.append(self[bottomLeft])
            }
        }
        
//        print(directionalElements)
        
        
        
        return directionalElements
    }
}

enum Seat: String {
    case floor = "."
    case empty = "L"
    case occupied = "#"
}

extension Seat: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}

struct SeatLayout {
    let seatLayout: Matrix<Seat>
    
    init(_ layout: String) {
        let layoutData = layout
            .components(separatedBy: "\n")
            .filter { $0 != "" }
            .map { Array($0).map { String($0) }  }
        
        let rowCount = layoutData.count
        let columnCount = layoutData.first!.count
        
        var startLayout:Matrix<Seat> = Matrix(rows: rowCount, columns: columnCount, defaultValue: .floor)
        
        for rowIndex in 0 ..< rowCount {
            for columnIndex in 0 ..< columnCount {
                startLayout[rowIndex, columnIndex] = Seat(rawValue: layoutData[rowIndex][columnIndex])!
            }
        }
        
        self.seatLayout = startLayout
    }
    
    init(_ layout: Matrix<Seat>) {
        self.seatLayout = layout
    }
    
    func reseat() -> SeatLayout {
        var newSeatLayout = seatLayout
        
        for r in 0..<seatLayout.rows {
            for c in 0..<seatLayout.columns {
                let currentSeat = seatLayout[r, c]
                let adjacentSeats = seatLayout.getAdjacentElements(row: r, column: c)
                let occupiedAdjacentSeats = adjacentSeats.filter { $0 == .occupied }
                
                if (currentSeat == .empty) {
                    if (occupiedAdjacentSeats.count == 0) {
                        newSeatLayout[r, c] = .occupied
                    }
                }
                if (currentSeat == .occupied) {
                    if (occupiedAdjacentSeats.count >= 4) {
                        newSeatLayout[r, c] = .empty
                    }
                }
            }
        }
        
        return SeatLayout(newSeatLayout)
    }
        
    func reseatUsingNewRules() -> SeatLayout {
        var newSeatLayout = seatLayout
        
        for r in 0..<seatLayout.rows {
            for c in 0..<seatLayout.columns {
                let currentSeat = seatLayout[r, c]
                let directionalElements = seatLayout.getDirectionalElements(row: r, column: c)
                print(directionalElements)
                let adjacentSeats = directionalElements.getAdjacentElements { $0 != .floor }
                print(adjacentSeats)
                let occupiedAdjacentSeats = adjacentSeats.filter { $0 == .occupied }
                
                if (currentSeat == .empty) {
                    if (occupiedAdjacentSeats.count == 0) {
                        newSeatLayout[r, c] = .occupied
                    }
                }
                if (currentSeat == .occupied) {
                    if (occupiedAdjacentSeats.count >= 4) {
                        newSeatLayout[r, c] = .empty
                    }
                }
            }
        }
        
        return SeatLayout(newSeatLayout)
    }
    
    func findStabilizedSeatLayout() -> SeatLayout {
        var previousSeatLayout = self
        var newSeatLayout = previousSeatLayout.reseat()
        var reseats = 0;
        
        while (previousSeatLayout != newSeatLayout) {
            previousSeatLayout = newSeatLayout
            newSeatLayout = previousSeatLayout.reseat()
            reseats += 1
        }
        
        return newSeatLayout
    }
    
    func findStabilizedSeatLayoutUsingNewRules() -> SeatLayout {
        var previousSeatLayout = self
        var newSeatLayout = previousSeatLayout.reseatUsingNewRules()
        var reseats = 0;
        
        while (previousSeatLayout != newSeatLayout) {
            previousSeatLayout = newSeatLayout
            newSeatLayout = previousSeatLayout.reseatUsingNewRules()
            reseats += 1
        }
        
        return newSeatLayout
    }
    
    func getNumberOfSeatsWhichAre(_ status: Seat) -> Int {
        return seatLayout.grid.filter { $0 == status }.count
    }
}

extension SeatLayout: Hashable {
    static func == (lhs: SeatLayout, rhs: SeatLayout) -> Bool {
        return lhs.seatLayout.description == rhs.seatLayout.description
    }
}

var exampleLayout = """
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

var exampleSeatLayout = SeatLayout(exampleLayout)
var stabilizedExampleSeatLayout = exampleSeatLayout.findStabilizedSeatLayout()
var numberOfOccupiedExampleSeats = stabilizedExampleSeatLayout.getNumberOfSeatsWhichAre(.occupied)
print(numberOfOccupiedExampleSeats)

var inputLayout = Bundle.module.loadTextdataFromFile(name: "input11")

var inputSeatLayout = SeatLayout(inputLayout)
var stabilizedInputSeatLayout = inputSeatLayout.findStabilizedSeatLayout()
var numberOfOccupiedInputSeats = stabilizedInputSeatLayout.getNumberOfSeatsWhichAre(.occupied)
print(numberOfOccupiedInputSeats)
