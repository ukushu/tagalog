import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    let realmWrap = RealmWrapper()
    @Published var translations: [UniDictObj] = []
    
    @Published var selection: Set<String> = []
    
    init() {
        refresh()
    }
    
    func refresh() {
        translations = realmWrap.translations
            .map{ $0 }
    }
}

//class Translator {
//    let lengFrom: Language
//    let lengTo: Language
//
//    init(lengFrom: Language, lengTo: Language) {
//        self.lengFrom = lengFrom
//        self.lengTo = lengTo
//    }
//}
