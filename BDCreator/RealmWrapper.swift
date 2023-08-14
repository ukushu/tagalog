import Foundation
import AppCore
import SwiftUI
import RealmSwift

class RealmWrapper {
    static let shared = RealmWrapper()
    
    private let realm: Realm
    
    var translations: Results<UniDictObj> { realm.objects(UniDictObj.self) }
    
    var allLesssonsNums: [Int] { realm.objects(UniDictObj.self).distinct(by: ["lessonNum"]).compactMap{ $0.lessonNum }.sorted() }
    
    init() {
        let config = Realm.Configuration(encryptionKey: nil, schemaVersion: 4)
        
        self.realm = try! Realm(configuration: config)
        
        print("realm initiated: \(realm.configuration.fileURL!.path)")
    }
    
    @discardableResult
    func addTranslation(obj: UniDictObj) -> Bool {
        do {
            try realm.write {
                realm.add(obj)
            }
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func modify(key: String, withValues obj: UniDictObj) -> Bool {
        do {
            try realm.write {
                guard let tmp = realm.object(ofType: UniDictObj.self, forPrimaryKey: key) else { return false }
                
                tmp.isWord = obj.isWord
                tmp.isPhrase = obj.isPhrase
                tmp.audioUrl = obj.audioUrl
                tmp.eng = obj.eng
                tmp.translation = obj.translation
                tmp.langTo = obj.langTo
                tmp.lessonNum = obj.lessonNum
                
                return true
            }
            return true
        } catch {
            return false
        }
    }
    
    func delete(translation obj: UniDictObj) {
        do {
            try realm.write {
                realm.delete(obj)
            }
        } catch let e {
            let dlg = SheetDialogType.view(view: AnyView( ErrorView(error: e)))
            GlobalDialog.Open(view: dlg)
        }
    }
}

class UniDictObj: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    
    //Lang from - always English
    @Persisted var langTo = Language.English.rawValue
    @Persisted var eng: String
    @Persisted var translation: String
    
    @Persisted var lessonNum: Int?
   
    @Persisted var audioUrl: String?
    
    @Persisted var isWord: Bool
    @Persisted var isPhrase: Bool
}



extension UniDictObj {
    var wordsUsed: [String] {
        translation
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "___", with: "")
            .split(separator: " ")
            .map{ "\($0)".capitalizingFirstLetter() }
    }
}
