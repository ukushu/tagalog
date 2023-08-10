import Foundation
import SwiftUI
import AppCore
import AsyncNinja

class MainViewModel: NinjaContext.Main, ObservableObject {
    @Published var dialog : SheetDialogType = .none
    
    let realmWrap = RealmWrapper()
    @Published var translations: [UniDictObj] = []
    
    @Published var selection: Set<String> = []
    
    override init() {
        translations = realmWrap.translations.map{ $0 }
        
        super.init()
        
//        AppCore.signals
//            .subscribeFor( Signal.TaoGit.GlobalDialogs.Open.self )
//            .filter{ $0.wndId == self.wndId }
//            .map { $0.dlg }
//            .assign(on: self, to: \.dialog)
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
