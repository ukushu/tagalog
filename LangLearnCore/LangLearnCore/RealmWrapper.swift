import Foundation
import MoreSwiftUI
import SwiftUI
import RealmSwift
import Essentials

public class RealmWrapper {
    public static let shared = RealmWrapper()
    
    private let realm: Realm
    
    public var translations: Results<UniDictObj> { realm.objects(UniDictObj.self) }
    
    public var allLesssonsNums: [Int] { realm.objects(UniDictObj.self).distinct(by: ["lessonNum"]).compactMap{ $0.lessonNum }.sorted() }
    
    public init() {
        let config = Realm.Configuration(encryptionKey: nil, schemaVersion: 4)
        
        self.realm = try! Realm(configuration: config)
        
        print("realm initiated: \(realm.configuration.fileURL!.path)")
    }
    
    @discardableResult
    public func addTranslation(obj: UniDictObj) -> Bool {
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
    public func modify(key: String, withValues obj: UniDictObj) -> Bool {
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
    
    public func delete(translation obj: UniDictObj) -> R<Void> {
        Result{
            try realm.write {
                realm.delete(obj)
            }
        }
    }
}
