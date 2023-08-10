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
