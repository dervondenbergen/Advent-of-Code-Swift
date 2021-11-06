/// Day 4: Passport Processing

import Foundation
import Regex

// 2 Valid – Nr. 1 & Nr. 3
let exampleData = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""

enum EyeColor: String, Codable {
    case amb, blu, brn, gry, grn, hzl, oth
}

struct Passport {
    let byr: String? // (Birth Year)
    let iyr: String? // (Issue Year)
    let eyr: String? // (Expiration Year)
    let hgt: String? // (Height)
    let hcl: String? // (Hair Color)
    let ecl: EyeColor? // (Eye Color)
    let pid: String? // (Passport ID)
    let cid: String? // (Country ID) – Northpole Credentials has no Country ID
    
    func isValid() -> Bool {
        let fieldsExist = (
            byr != nil &&
            iyr != nil &&
            eyr != nil &&
            hgt != nil &&
            hcl != nil &&
            ecl != nil &&
            pid != nil
        )
        
        if (fieldsExist) {
            
            let validBirthYear = Int(byr!)! >= 1920 && Int(byr!)! <= 2002
            let validIssueYear = Int(iyr!)! >= 2010 && Int(iyr!)! <= 2020
            let validExpirationYear = Int(eyr!)! >= 2020 && Int(eyr!)! <= 2030

            let validHeight = Validator.hgt(heightString: hgt!)
            let validHaircolor = Validator.hcl(haircolorString: hcl!)
            
            let validPid = pid?.count == 9 && Int(pid!) != nil
            
//            print(
//                validBirthYear ,
//                validIssueYear ,
//                validExpirationYear ,
//                validHeight ,
//                validHaircolor ,
//                validPid
//            )
            
            return (
                validBirthYear &&
                validIssueYear &&
                validExpirationYear &&
                validHeight &&
                validHaircolor &&
                validPid
            )
            
        } else {
            return false
        }
    }
}

extension Passport: Codable {
    init(dictionary: [String: String]) throws {
        self = try JSONDecoder().decode(Passport.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    
    private enum CodingKeys: String, CodingKey {
        case byr, iyr, eyr, hgt, hcl, ecl, pid, cid
    }
}

struct Validator {
    static func hgt(heightString: String) -> Bool {
        let heightRegex = Regex(#"(?<number>\d+)(?<format>cm|in)"#)
        let match = heightRegex.firstMatch(in: heightString)
        
        if (match != nil) {
            let height = Int(match!.group(named: "number")!.value)!
            let format = match!.group(named: "format")!.value
            
//            print(height, format)
            
            if (format == "cm") {
                return height >= 150 && height <= 193
            }
            if (format == "in") {
                return height >= 59 && height <= 76
            }
        }
        
        return false
    }
    
    static func hcl(haircolorString: String) -> Bool {
        let haircolorRegex = Regex(#"#[0-9a-f]{6}"#)
        let match = haircolorRegex.firstMatch(in: haircolorString)
        
        if (match != nil) {
            return true
        }
        
        return false
    }
}

extension Passport {
    static func parsePassportText(_ passports: String) -> [Passport] {
        let passportStrings = passports.components(separatedBy: "\n\n")
        let passportParts = passportStrings.map { pass in pass.components(separatedBy: ["\n", " "]) }
        
        print(passportParts.count)
        
        let passKvRegex = Regex(#"(?<key>\w+):(?<value>.+)"#)
        var passes: [Passport] = []
        
        for (index, pass) in passportParts.enumerated() {
            var passData: [String: String] = [:]
//            print()
//            print(pass)
                        
            for kv in pass {
                let match = passKvRegex.firstMatch(in: kv)
                
                if (match?.groups != nil) {
                    
                
                
                let key = match!.group(named: "key")!.value
                let value = match!.group(named: "value")!.value
                
                passData.updateValue(value, forKey: key)
                    
                } else {
                    print("no match")
                }
            }
            
            
            
//            print(passData)
            
            do {
                let passport = try Passport(dictionary: passData)
                
//                print(index, passport)

                passes.append(passport)
                
            } catch {
//                print(index, "error")
            }
            
            

//

        }
        
        return passes
    }
}

//let examplePassports = Passport.parsePassportText(exampleData)

//print(examplePassports)

//let validExamplePassports = examplePassports.filter { $0.isValid() }

//print("Valid Passports from Example: \(validExamplePassports.count)")

let filePath = Bundle.main.path(forResource: "input04", ofType: "txt")
let contentData = FileManager.default.contents(atPath: filePath!)
let content = String(data:contentData!, encoding: .utf8)!

let inputData = content

let inputPassports = Passport.parsePassportText(inputData)

//print(inputData)
//print(inputPassports)

let validInputPassports = inputPassports.filter { $0.isValid() }
print("Valid Passports from Input: \(validInputPassports.count)")

//let testValidPassports = """
//pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
//hcl:#623a2f
//
//eyr:2029 ecl:blu cid:129 byr:1989
//iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
//
//hcl:#888785
//hgt:164cm byr:2001 iyr:2015 cid:88
//pid:545766238 ecl:hzl
//eyr:2022
//
//iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
//"""
//
//let testPassports = Passport.parsePassportText(testValidPassports)
//
//for pass in testPassports {
//    print("\(pass): \(pass.isValid())")
//}
