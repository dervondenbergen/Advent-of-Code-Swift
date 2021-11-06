/// Day 2: Password Philosophy

import PlaygroundSupport
import Foundation
import Regex

let useOfficialPasswordPolicy = true

struct PasswordPolicy {
    let minAmount: Int
    let maxAmount: Int
    let char: String
    
    var officialPolicyRegex: Regex {
        get {
            print("test")
            return Regex("a")
        }
    }
}

struct Password {
    let password: String
    let policy: PasswordPolicy
    
    func isValid() -> Bool {
        /// Rule from old Job
        
        if (!useOfficialPasswordPolicy) {
        
            let charRegex = try! Regex("\(policy.char)")
            let matches = charRegex.allMatches(in: password)

            return (matches.count >= policy.minAmount && matches.count <= policy.maxAmount)
            
        } else {
        
        /// Official Toboggan Corporate Policy
        
            let firstEqualChar = String(password[password.index(
                password.startIndex,
                offsetBy: policy.minAmount - 1
            )]) == policy.char
            
            let secondEqualChar = String(password[password.index(
                password.startIndex,
                offsetBy: policy.maxAmount - 1
            )]) == policy.char
            
            return firstEqualChar != secondEqualChar
            
        }
        
    }
}

extension Password {
    static func parsePasswordsText(_ passwords: String) -> [Password] {
        let pwdRegex = Regex(#"(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<pwd>\w+)"#)
        var pwds: [Password] = []
        
        let matches = pwdRegex.allMatches(in: passwords)
        
        for match in matches {
            let min = Int(match.group(named: "min")!.value)!
            let max = Int(match.group(named: "max")!.value)!
            let char = match.group(named: "char")!.value
            let pwd = match.group(named: "pwd")!.value
            
            let policy = PasswordPolicy(
                minAmount: min,
                maxAmount: max,
                char: char
            )
            
            let password = Password(
                password: pwd,
                policy: policy
            )
            
            pwds.append(password)
        }
        
        return pwds
    }
}

let exampleData = """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""

var examplePasswords = Password.parsePasswordsText(exampleData)

//print(exampleData)
//print(examplePasswords)

//for eP in examplePasswords {
//    print("Password \(eP.password) is valid? \(eP.isValid())")
//}

//var validExamplePasswords = examplePasswords.filter { $0.isValid() }
//
//for veP in validExamplePasswords {
//    print("Password \(veP.password) is valid? \(veP.isValid())")
//}

let filePath = Bundle.main.path(forResource:"input02", ofType: "txt")
let contentData = FileManager.default.contents(atPath: filePath!)
let content = String(data:contentData!, encoding: .utf8)!

let inputData = content

let inputPasswords = Password.parsePasswordsText(inputData)

//print(inputData)
//print(inputPasswords)

let validInputPasswords = inputPasswords.filter { $0.isValid() }

print("Valid Passwords from Input: \(validInputPasswords.count)")
