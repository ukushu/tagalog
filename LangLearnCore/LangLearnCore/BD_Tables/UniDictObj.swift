import Foundation
import RealmSwift
import Essentials

public class UniDictObj: Object {
    @Persisted(primaryKey: true) public var id: String = UUID().uuidString
    
    //Lang from - always English
    @Persisted public var langTo = LLLanguage.English.rawValue
    @Persisted public var eng: String
    @Persisted public var translation: String
    
    @Persisted public var lessonNum: Int?
   
    @Persisted public var audioUrl: String?
    
    @Persisted public var isWord: Bool
    @Persisted public var isPhrase: Bool
}

public extension UniDictObj {
    var wordsUsed: [String] {
        translation
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "___", with: "")
            .split(separator: " ")
            .map{ "\($0)".capitalizingFirstLetter() }
    }
}
