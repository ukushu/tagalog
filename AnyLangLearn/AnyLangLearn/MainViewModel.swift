import Foundation
import LangLearnCore
import AppCore
import Essentials

class MainViewModel: NinjaContext.Main, ObservableObject {
    public static var shared = MainViewModel()
    
    private let realmWrap = RealmWrapper()
    
    @Published var translations: [UniDictObj] = []
    @Published var allLessonsNumbers: [Int] = []
    
    @Published var selection: Set<UniDictObj> = []
    
    @Published var langFrom: LLLanguage = .English
    @Published var langTo: LLLanguage = .Tagalog
    @Published var filterLessonNum: Int = 1
    
    private override init() {
        super.init()
        
        realmWrap.translations.notifications()
            .map(context: self) { me, _ in
                me.realmWrap.translations
                    .filter { $0.lessonNum == me.filterLessonNum }
                    .map{ $0 }
                    .sorted(by: {
                        if $0.langTo != $1.langTo {
                            return $0.langTo < $1.langTo
                        }
                        
                        return $0.lessonNum ?? 999 < $1.lessonNum ?? 999
                    })
            }
            .assign(on: self, to: \.translations)
            .onUpdate(context: self){ me, _ in
                me.allLessonsNumbers = me.realmWrap.allLesssonsNums
            }
    }
}
