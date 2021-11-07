import Foundation

public struct Helpers {
    public static func loadTextdataFromFile(name: String) -> String{
        let filePath = Bundle.main.path(forResource: name, ofType: "txt")
        let contentData = FileManager.default.contents(atPath: filePath!)
        let content = String(data:contentData!, encoding: .utf8)!

        return content
    }
}
