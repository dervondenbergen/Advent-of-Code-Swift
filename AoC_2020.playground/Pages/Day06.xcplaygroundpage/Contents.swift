/// Day 6: Custom Customs

import Foundation

let usePart1Solution = false

let exampleData = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""

let startSet = Set( "abcdefghijklmnopqrstuvwxyz".map { String($0) } )

func getCustomsDeclerationCount(from answers: String) -> Int {
    if (usePart1Solution) {
        /// Part 1
        
        let answersForms = answers.components(separatedBy: "\n\n").map {
            Set( $0.map { String($0) } .filter { $0 != "\n" } )
        }
    //    print(exampleForms)
        let answersCount = answersForms.map { $0.count } .reduce(0, +)
    //    print(exampleCount)
        return answersCount
        
    } else {
        /// Part 2
        
        let answersForms = answers.components(separatedBy: "\n\n").map {
            $0.components(separatedBy: "\n").filter {
                /// last line hast new line, which looks like a person with no answer →
                /// https://www.reddit.com/r/adventofcode/comments/k8e04a/comment/gexilkb/

                $0 != ""
            }
        }
                
        let answersCounts: [Int] = answersForms.map {
            
            let people = $0.map { Set( $0.map { String($0) } ) }
            
            let intersection = people.reduce(startSet, { newSet, person in
//                print("from \n    \(newSet.sorted()) and \n    \(person.sorted()) to \n    \(newSet.intersection(person).sorted())")
                return newSet.intersection(person)
            }).sorted()
                        
            return intersection.count
            
        }
        
        let answersCount = answersCounts.reduce(0, +)
        
        return answersCount
        
    }
}

let exampleCount = getCustomsDeclerationCount(from: exampleData)
print("Example Count: \(exampleCount) should be \(usePart1Solution ? 11 : 6).")

let content = Helpers.loadTextdataFromFile(name: "input06")
let inputCount = getCustomsDeclerationCount(from: content)
print("Input Count: \(inputCount)")
