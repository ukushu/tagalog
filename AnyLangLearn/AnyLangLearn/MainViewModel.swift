import Foundation
import LangLearnCore
import AppCore
import Essentials

class MainViewModel: NinjaContext.Main, ObservableObject {
    public static var shared = MainViewModel()
    
    private let realmWrap = RealmWrapper()
    
    @Published var translations: [UniDictObj] = []
    @Published var allLessonsNumbers: [Int] = []
    
    private override init() {
        super.init()
        
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
}
