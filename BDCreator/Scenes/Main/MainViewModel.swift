import Foundation
import SwiftUI
import AppCore
import AsyncNinja
import AnyLangLearnCore

class MainViewModel: NinjaContext.Main, ObservableObject {
    static let shared = MainViewModel()
    
    @Published var dialog : SheetDialogType = .none
    
    private let realmWrap = RealmWrapper()
    @Published var translations: [UniDictObj] = []
    @Published var allLessonsNumbers: [Int]
    
    @Published var selection: Set<UniDictObj> = []
    
    @Published var filterLanguage: Language = .Tagalog
    @Published var filterLessonNum: Int = 1
    @Published var filterHideWords = false
    
    private override init() {
        print("MainViewModel init")
        translations = realmWrap.translations.map { $0 }
        allLessonsNumbers = realmWrap.allLesssonsNums
        
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
            .map(context: self) { me, _ in me.realmWrap.translations.map{ $0 }.sorted(by: {
                if $0.langTo != $1.langTo {
                    return $0.langTo < $1.langTo
                }
                
                return $0.lessonNum ?? 999 < $1.lessonNum ?? 999
            }) }
            .assign(on: self, to: \.translations)
            .onUpdate(context: self){ me, _ in
                me.allLessonsNumbers = me.realmWrap.allLesssonsNums
            }
    }
    
    func delete(translation obj: UniDictObj) {
        translations.removeFirst(where: { $0.id == obj.id })
        
        DispatchQueue.main.async {
            self.realmWrap.delete(translation: obj)
        }
    }
}
