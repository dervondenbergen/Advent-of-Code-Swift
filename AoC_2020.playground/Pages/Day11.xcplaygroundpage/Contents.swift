/// Day 11: Seating System

import Foundation

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

//var inputLayout = Helpers.loadTextdataFromFile(name: "input11")

let inputLayout = """
LLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLL.LLLL.L.LLLLLLL.LLLLLLL.LLLLLL.LL.LLLL.LLLLLLLLLLLLLLL
LLL.LLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLLL.LLLLLLL.LLLL.LLL....LLL.LLL.LLLLLLL.LLL.LLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLL.LLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLL.LLLL.LLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLL.LLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLL.LLLL.LLLLLLL.L.LLL.LLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLL.LLL..LL.LLL
LLLLLLLLL.LLLLLLLLLLL.LLLLL.LLL.LLLLLL.LLLL.LL.L.LLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.L.LLLLLLLLLL.LLL.LLLL.LLLLLLLLLLLLL.LLL.LLLLLLLLLLLLLLLLLL.LLLLLLLLLLL
....L..L....L...L.......L.LL.....L..L...LLLL.LLL..L.L...LL..L...LL.....L..LL.....L....L.L..L
LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLL.LLL.LLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL.LL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLL..LLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLL.LLLLLL.LL..LLL.LLLLLLLLLLLLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLL
LLL..LLLL.LLLLL.LLLLLLLL.LLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLLLL.LLLLLLLLLLL.LLLL.LLLLLLLLL.L.LLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLL.LLLL.LLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLL.LLLLL.LLLLLLLLLLLLLLLLLLLLL..LLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
.L..L......L.L....L...L..........L.L....L...LL....LL....LL...LLL....LL..L...L...L.........L.
LLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLL.LL.LLLLLLLLLLLLLLLLLLLLL..LLLLLLLLLLLLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLL.LLLLLLL.LLLLLL.LLLLLLLLLLL.LL.LLLLLLL.LLLLLLL.L.LLL.LLLL.LLLLLLLLLLL
LLLLLL.LL.LLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLL.LL.LLLLLLLLLLLLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLL..LLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLL.L.LLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLL.LL.L.LLLLLLLLLLLLLL.L.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLLLLLLLLLLLL.LL.LLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
..L.L.L..L.L.....LL..L........L..L....L...LL.........L.L.L.L..L......L.........L..L....L....
LLLLLLL.LLLLLLLLLLLLL.LLLLLLLLLLLLLL.L.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLL.L.LLLLLLLLLLLLLLL.LLLL
LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLL
LLLL.LLLL.LLLLLLLLLL..LLLLLLLLL.LLLLLLLLLLL.LLL.LLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLL.LLLLLLLLLLL
LLLL.LLLL.LLL..LLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
LLLLL.LLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLL.LLLL.LLLLLLLLLLL
LLLLLLLLLLLLLLLL.LLLL.LLLLLLL.L.LL.LLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLL.L.LLLLLLLL.LL.LLLLLLLL
LLLLLLL.LLLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLL.LLLLLLLLLLL
L...L.......LL.LL.L....L...L.....L.......L.........L.L.L..LL.L.L.L.L..L....L.L...L.L.LL.....
LL.LLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLL..LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLL.LLL.LLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLL.LLL.LLLLLL.
LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLL.LLLLLL..LLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.L.LLLLLLLL.
LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLL..LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLL.LL
..LLL.L..L..L..L..L..L.L...LL..L.....LLL.L..LL.....LLL.......L.L...L........LL........L....L
LLLLLLLLL.LLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLL.LLLLLLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL
L.LLLLLLL.LLLL.LLLLLL.LLLLLLLLL.LL.LLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LL.LL...L......L.L.....L.........L....L...L..L..LLL.L...L......L.L.....LL..LL..LLL....L..L.L
LLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLL
LL.LLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLL.L.LLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLL.LLLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.L.LLLLLL.L.LLLLLLLLL
LLLLLLL.L.LLLL.LLLL.L.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLL.LLLLLLLL.LL
L..L.L....L......LLLL...L....LL...L..LLL......LLL.LL.LLL...LL..L...LLL........L.....LL.L.LLL
LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLL.LL.LLLLLLLL.LLLLLLLLLLL
LLLL.LLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLL.L.LLLLLLL.LLLLLLL.LLLLLLL.L.LL.LLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLL..LLLLLL.LLLL.LLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LL.......L......L...LL.......LL.LL.LL.L.LL.L..L.......L.L.LLLL.LL...LL......LLL..L....LLL...
LLLLLLLLL.LLL..LLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLLL.LLLLL.LLLLLLLL.LL.LLLLLLLLL.L.LLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLL.LLL
LLLLLLLLLLLLLLLLLLLLL.L.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLLLLL.L.LLLLLLLL.LLLLLLLLLLL
LLLLLLL.LLLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLL..LLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLL.LLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLL.L.LLLLLLLLLLLLLLLLLLLL
...L..L..L..L...L.........L.L.L..LLL.....LL......L..LLL..L.L.......L.L.L..LLL...........L...
LLLLLLLLL.LLLL..LLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLL.LLL.LLLLLLLL.LLLLLLLLLLL
LLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLLLL.LLLL.L.LLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.L.LLLLLLLLL
LLLLLLLLL.LLLL.LLL..L.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.L.LLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLL.LLL.LLLLLLLLLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLL.LLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLL.LLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLL.LLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLL.LLLLLLL.LL.LLLLLLLLL.LLLLLLLL.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL..LLLLLLLLLLLLLLLLLLL
..L.LLL.....L....L.L.L..L.L..L.L..LL.......L.L.L......L..L..L..L..L.......L...LL..LL..L...LL
LLLLLLLLL.LL.LLLL.LLL.LLLLLLLLLL.LLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLLLLL..LLLLLL.L.LLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLL.LL.LLLLLL.LLLLLL.L.LL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLLLLLL.LL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.L.LLLLLLL.LLLLLL.LLLL.LLLLLLLLLLLLLLLLL.LLL.LLLL..LLLLLLLL.LLLLLLLLLLL
LLLLLLLLLLLLL..LLLLLLLLLLLLLLLL.LLLL.L.LLLLLLLLLLLLLL.LLLLLLL.LLLLLLLL..LL.LLLLL.LLLLLLLLLLL
LLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLLLLL.L
LLLL.LLLL.LLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLL.LLLLLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLL.LLLLLL.LLLL
LLLLLLLLLLLLLLLLLLLLL.LLLLLLLL..LLLLLLLLLLL.LLLLLLLLL.L.LLLLLLLLLLLLLLL.LLLLLLLL..LLLLLLLLLL
LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLL.LLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLL.LLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL
LLLLLLLLL.LLLLLLL.LLL.LLLLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLL..LLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
L.LLLLLLLL.LLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LLLLL.LLL.LLLLLL..LLLLLLLLLLLLLLLLLL.LLL.LLLLLLL
"""

var inputSeatLayout = SeatLayout(inputLayout)
var stabilizedInputSeatLayout = inputSeatLayout.findStabilizedSeatLayout()
var numberOfOccupiedInputSeats = stabilizedInputSeatLayout.getNumberOfSeatsWhichAre(.occupied)
print(numberOfOccupiedInputSeats)
