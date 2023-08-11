import Foundation
import AppCore
import SwiftUI
import RealmSwift

class RealmWrapper {
    static let shared = RealmWrapper()
    
    private let realm: Realm
    
    var translations: Results<UniDictObj> { realm.objects(UniDictObj.self) }
    
    init() {
        let config = Realm.Configuration(encryptionKey: nil, schemaVersion: 2)
        
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

enum Language: String, CaseIterable ,RawRepresentable {
    case English
    case Tagalog
    case Ukrainian
}



class UniDictObj: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    
    //Lang from - always English
    @Persisted var langTo = Language.English.rawValue
    @Persisted var eng: String
    @Persisted var translation: String
    
    @Persisted var lessonNum: Int?
}
