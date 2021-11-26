///

import Foundation

struct Bus {
    let number: Int
    let position: Int
}

extension Bus {
    func hasPerfectDepartureAt(timestamp: Int) -> Bool {
        return (timestamp + position) % number == 0
    }
}

struct BusDeparture {
    let bus: Bus
    let departureTime: Int
    
    init(_ bus: Bus, earliest startingTime: Int) {
        self.bus = bus
        self.departureTime = Int(ceil(Double(startingTime) / Double(bus.number))) * bus.number
    }
}

extension BusDeparture: CustomStringConvertible {
    var description: String {
        "Bus \(bus.number) departs at \(departureTime)"
    }
}

struct BusNote {
    let departureTime: Int
    let bussesInService: [Bus]
    
    init (_ note: String) {
        let parts = note.components(separatedBy: "\n")
        self.departureTime = Int(parts.first!)!
        self.bussesInService = parts.last!
            .components(separatedBy: ",")
            .enumerated()
            .filter { $0.element != "x" }
            .map {
                Bus(number: Int($0.element)!, position: $0.offset)
            }
    }
    
    func getDepartureTimesForBusses() -> [BusDeparture] {
        return bussesInService.map {
            BusDeparture($0, earliest: self.departureTime)
        }.sorted {
            $0.departureTime < $1.departureTime
        }
    }
    
    func findPerfectTimestamp() -> Int {
        let busWithLongestTime = bussesInService.sorted { $0.number > $1.number } .first!
        let startDepartureTime = BusDeparture(busWithLongestTime, earliest: self.departureTime)
        
        var possibleDepartureTime = startDepartureTime.departureTime - startDepartureTime.bus.position
        
        while true {
            let possibleDepartureTimeIsPerfect = bussesInService
                .map {
                    $0.hasPerfectDepartureAt(timestamp: possibleDepartureTime)
                }
                .allSatisfy {
                    $0 == true
                }
            
            if possibleDepartureTimeIsPerfect {
                break
            } else {
                possibleDepartureTime += busWithLongestTime.number
            }
        }
        
        return possibleDepartureTime
    }
    
    func busResult() -> Int {
        let nextBus = getDepartureTimesForBusses().first!
        return (nextBus.departureTime - self.departureTime) * nextBus.bus.number
    }
}

let exampleNote = """
939
7,13,x,x,59,x,31,19
"""

let exampleBusNote = BusNote(exampleNote)
print(exampleBusNote.busResult())
print(exampleBusNote.findPerfectTimestamp())

let inputNote = """
1002632
23,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,829,x,x,x,x,x,x,x,x,x,x,x,x,13,17,x,x,x,x,x,x,x,x,x,x,x,x,x,x,29,x,677,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,x,x,19
"""

let inputBusNote = BusNote(inputNote)
print(inputBusNote.busResult())
// perfect Timestamp doesn't work with large input, as while loop is used
// possible solution uses "chinese remainder theorem" https://www.reddit.com/r/adventofcode/comments/kc4njx/2020_day_13_solutions/
// print(inputBusNote.findPerfectTimestamp())
