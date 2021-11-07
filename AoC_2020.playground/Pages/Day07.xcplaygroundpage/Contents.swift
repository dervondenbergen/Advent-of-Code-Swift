/// Day 7: Handy Haversacks

import Foundation

let exampleRules = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""

struct Bags {
    let bags: [Bag]
}

struct Bag {
    let feature: String
    let color: String
    var contains: [Bag]? = nil
    
    var amount: Int? = nil
    
    func getNestedBagsFromBagslist(_ bags: Bags) -> Int {
        if (self.contains != nil) {
            
            var searchBagContainsCount = 0
            
            self.contains!.forEach {
                let containsBag = $0
                
//                print(containsBag)
                
                searchBagContainsCount += containsBag.amount!
                
                let bag = bags.searchBag(matching: containsBag)!
                
//                print(bag)
                
                if (bag.contains != nil) {
                    searchBagContainsCount += (containsBag.amount! * bag.getNestedBagsFromBagslist(bags))
                }
            }
            
            return searchBagContainsCount
            
        } else {
            return 0
        }
    }
}

extension Bag: CustomStringConvertible {
    var description: String {
        get {
            return "feature: \(feature) / color: \(color)"
        }
    }
}

extension Bag: Hashable {
    static func == (lhs: Bag, rhs: Bag) -> Bool {
        let sameFeature = lhs.feature == rhs.feature
        let sameColor = lhs.color == rhs.color
        
        return sameFeature && sameColor
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(feature)
        hasher.combine(color)
    }
}

extension Bags {
    func searchBag(matching searchBag: Bag) -> Bag? {
        return self.bags.first(where: {
            $0 == searchBag
        })
    }
    
    func searchBagsContaining (_ searchBag: Bag) -> Bags {
        var bagsContainingSearchBag: [Bag] = []
        
        for bag in self.bags {
            if (bag.contains != nil) {
                let containsSearchBag = bag.contains!.contains(searchBag)
                if (containsSearchBag) {
                    bagsContainingSearchBag.append(bag)
                    
                    let possibleBagsContaingBag = self.searchBagsContaining(bag)
                    
                    if (possibleBagsContaingBag.bags.count > 0) {
                        bagsContainingSearchBag.append(contentsOf: possibleBagsContaingBag.bags)
                    }
                }
            } else {
                continue
            }
        }
        
        return Bags(bags: bagsContainingSearchBag)
    }
    
    static func parseBagRules (rules rulesText: String) -> Bags {
        let rules = rulesText.components(separatedBy: "\n").filter { $0 != "" }
        
        let transformedRules: [Bag] = rules.map {
            let parts = $0.components(separatedBy: " contain ")
            
            var bag = parts.first!.components(separatedBy: " ")
            bag.removeLast()
            
            let feature = bag.first!
            let color = bag.last!
            
            var containsRules = parts.last!
            containsRules.removeLast()
            let cccrrr: [[String]?] = containsRules.components(separatedBy: ", ").map {
                var p: [String] = $0.components(separatedBy: " ")
                p.removeLast()
                if (p.first! != "no") {
                    return p
                } else {
                    return nil
                }
            } .filter {
                $0 != nil
            }
            
            var cccrrrrContains: [Bag]? = cccrrr.count > 0 ? [] : nil
            
            cccrrr.forEach {
                var b = $0!
                let amountText = b.removeFirst()
                let amount = Int(amountText)!
                let bag = Bag(feature: b.first!, color: b.last!, amount: amount)
                
                cccrrrrContains!.append(bag)
            }
//            print(cccrrrrContains)
            
            return Bag(feature: feature, color: color, contains: cccrrrrContains)
        }
        
//        print(transformedRules)
        
        return Bags(bags: transformedRules)
    }
}

func showBags(bags: [Bag], inset: String = "") -> Void {
    for bag in bags {
        print("\(inset)Bag \(bag.feature) \(bag.color).", terminator: "")
        if (bag.contains != nil && bag.contains!.count > 0) {
            print(" Contains other Bags:")
            showBags(bags: bag.contains!, inset: inset + "    ")
        } else {
            print()
        }
    }
}

let searchBagFeatures = Bag(feature: "shiny", color: "gold")


let exampleBaglist = Bags.parseBagRules(rules: exampleRules)
let exampleSearchBag = exampleBaglist.searchBag(matching: searchBagFeatures)!

let bagsContainingExampleSearchBag = exampleBaglist.searchBagsContaining(exampleSearchBag)
let bagsContainingExampleSearchBagWithoutDuplicates = Set(bagsContainingExampleSearchBag.bags)

print("Example List – Amount of Bags nesting Searchbag (\(exampleSearchBag)): \(bagsContainingExampleSearchBagWithoutDuplicates.count)")

let exampleBagCount = exampleSearchBag.getNestedBagsFromBagslist(exampleBaglist)
print("Example List – Amount of Bags contained in Searchbag (\(exampleSearchBag)): \(exampleBagCount)")


var inputRules = Helpers.loadTextdataFromFile(name: "input07")
let inputBaglist = Bags.parseBagRules(rules: inputRules)
let inputSearchBag = inputBaglist.searchBag(matching: searchBagFeatures)!

let bagsContainingInputSearchBag = inputBaglist.searchBagsContaining(inputSearchBag)
let bagsContainingInputSearchBagWithoutDuplicates = Set(bagsContainingInputSearchBag.bags)

print("Input List – Amount of Bags nesting Searchbag (\(inputSearchBag)): \(bagsContainingInputSearchBagWithoutDuplicates.count)")

let inputBagCount = inputSearchBag.getNestedBagsFromBagslist(inputBaglist)
print("Input List – Amount of Bags contained in Searchbag (\(inputSearchBag)): \(inputBagCount)")
