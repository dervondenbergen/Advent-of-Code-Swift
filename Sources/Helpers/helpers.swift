import Foundation

public struct Helpers {
    public static func loadTextdataFromFile(name: String, in bundle: Bundle) -> String{
        let filePath = bundle.path(forResource: name, ofType: "txt")
        let contentData = FileManager.default.contents(atPath: filePath!)
        let content = String(data:contentData!, encoding: .utf8)!

        return content
    }
}

extension Bundle {
    public func loadTextdataFromFile(name: String) -> String {
        return Helpers.loadTextdataFromFile(name: name, in: self)
    }
}

public extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
