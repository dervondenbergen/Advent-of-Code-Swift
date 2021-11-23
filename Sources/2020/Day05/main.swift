/// Day 5: Binary Boarding

import Foundation
import Helpers

struct Seat {
    let code: String
    let row: Int
    let column: Int
    
    var seatId: Int {
        get {
            return row * 8 + column
        }
    }
    
    var description: String {
        return "\(code): row \(row), column \(column), seat ID \(seatId)."
    }
}

func seatCodeDecoder(seatCode: String) -> Seat {
    var rowChange = 64
    var columnChange = 4
    
    var rowStart = 0
    var rowEnd = 127
    var columnStart = 0
    var columnEnd = 8
    
    for part in seatCode {
        
        if (part == "F") {
            rowEnd = rowEnd - rowChange
            rowChange = rowChange / 2
        }
        
        if (part == "B") {
            rowStart = rowStart + rowChange
            rowChange = rowChange / 2
        }
        
        if (part == "L") {
            columnEnd = columnEnd - columnChange
            columnChange = columnChange / 2
        }
        
        if (part == "R") {
            columnStart = columnStart + columnChange
            columnChange = columnChange / 2
        }
        
    }
    
    return Seat(code: seatCode, row: rowStart, column: columnStart)
}

//let testSeatCodes = [
//    "FBFBBFFRLR",
//    "BFFFBBFRRR",
//    "FFFBBBFRRR",
//    "BBFFBBFRLL",
//]
//
//for test in testSeatCodes {
//    let seat = seatCodeDecoder(seatCode: test)
//    print("\(seat.code): row \(seat.row), column \(seat.column), seat ID \(seat.seatId).")
//}

let content = Bundle.module.loadTextdataFromFile(name: "input05")

var inputSeatCodes = content.components(separatedBy: "\n")
inputSeatCodes.removeLast()

let inputSeats = inputSeatCodes.map { seatCodeDecoder(seatCode: $0) }
let sortedSeats = inputSeats.sorted {
    $0.seatId < $1.seatId
}

print("First Seat: \(sortedSeats.first!.description)")
print("Last Seat: \(sortedSeats.last!.description)")
print("Seat Amount: \(sortedSeats.count)")

for seatIndex in 1...sortedSeats.count - 2 {
    let seatPrev = sortedSeats[ sortedSeats.index(0, offsetBy: seatIndex - 1) ]
    let seat = sortedSeats[ sortedSeats.index(0, offsetBy: seatIndex) ]
    let seatNext = sortedSeats[ sortedSeats.index(0, offsetBy: seatIndex + 1) ]
    
    if (seatNext.seatId != seat.seatId + 1) {
//        print(seat, seat.seatId, "next will be", seatNext, seatNext.seatId)
        print("Empty Seat (ID): \(seat.seatId + 1)")
    }
    
//    if (seatPrev.seatId != seat.seatId - 1) {
//        print(seat, seat.seatId, "prev will be", seatPrev, seatPrev.seatId)
//    }
    
}
