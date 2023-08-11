import Foundation
import SwiftUI
import AppCore
import AsyncNinja

class MainViewModel: NinjaContext.Main, ObservableObject {
    static let shared = MainViewModel()
    
    @Published var dialog : SheetDialogType = .none
    
    let realmWrap = RealmWrapper()
    @Published var translations: [UniDictObj] = []
    
    @Published var selection: Set<String> = []
    
    private override init() {
        print("MainViewModel init")
        translations = realmWrap.translations.map { $0 }
        
        super.init()
        
        AppCore.signals
            .subscribeFor( Signal.OpenDialog.self )
            .map { $0.dlg }
            .assign(on: self, to: \.dialog)
        
        AppCore.signals
            .subscribeFor( Signal.CloseDialog.self)
            .map { _ in SheetDialogType.none }
            .assign( on: self, to: \.dialog )
        
        realmWrap.translations.notifications()
            .map(context: self) { me, _ in me.realmWrap.translations.map{ $0 }.sorted(by: { $0.lessonNum ?? 999 < $1.lessonNum ?? 999 }) }
            .assign(on: self, to: \.translations)
    }
    
    
    func delete(translation obj: UniDictObj) {
        translations.removeFirst(where: { $0.id == obj.id })
        
        DispatchQueue.main.async {
            self.realmWrap.delete(translation: obj)
        }
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
