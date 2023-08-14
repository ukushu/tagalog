import Foundation
import SwiftUI

struct AddTranslationView: View {
    @State var transSelection = Language.Tagalog
    
    @State var eng: String = ""
    @State var translation: String = ""
    @State var audioUrl: String = ""
    
    @State var lessonNum: String = "9999"
    
    @FocusState private var focus: Field?
    
    @State var isWord: Bool = false
    @State var isPhrase: Bool = false
    
    fileprivate let viewType: ViewType
    let id: String
    
    init() {
        viewType = .add
        id = ""
    }
    
    init(obj: UniDictObj) {
        self.audioUrl = obj.audioUrl ?? ""
        self.lessonNum = obj.lessonNum.map{ "\($0)" } ?? ""
        self.isWord = obj.isWord
        self.isPhrase = obj.isPhrase
        self.eng = obj.eng
        self.translation = obj.translation
        viewType = .modify
        self.id = obj.id
    }
    
    init(createFrom obj: UniDictObj) {
        self.audioUrl = obj.audioUrl ?? ""
        self.lessonNum = obj.lessonNum.map{ "\($0)" } ?? ""
        self.isWord = obj.isWord
        self.isPhrase = obj.isPhrase
        self.eng = obj.eng
        self.translation = obj.translation
        viewType = .createFrom
        self.id = obj.id
    }
    
    var body: some View {
        VStack {
            LanguageSelector(text: "Language to: ", sel: $transSelection)
            
            HStack {
                Toggle(isOn: $isWord) { Text("Is word") }
                
                Toggle(isOn: $isPhrase) { Text("Is phrase") }
            }
            
            if isPhrase {
                HStack {
                    Text("Lesson # :")
                    
                    TextField("", text: $lessonNum)
                        .onChange(of: lessonNum) { _ in
                            let tmp = lessonNum.filter{ $0.isNumber }
                            
                            guard lessonNum == lessonNum else { return }
                            
                            lessonNum = tmp
                        }
                        .focused($focus, equals: .f1)
                    
                    Button("-") {
                        lessonNum = ""
                    }
                }
            }
            
            HStack {
                Text("Eng:         ")
                TextField("Eng", text: $eng)
                    .focused($focus, equals: .f2)
            }
            
            HStack {
                Text("Translate:")
                TextField("Translate", text: $translation)
                    .focused($focus, equals: .f3)
            }
            
            HStack {
                Text("Audio:      ")
                TextField("Audio", text: $audioUrl)
                    .focused($focus, equals: .f4)
            }
            
            HStack {
                Button("Cancel", role: .cancel) {
                    GlobalDialog.Close()
                }
                
                Button(viewType.rawValue , role: .destructive) {
                    guard eng.count > 0 && translation.count > 0 else { return }
                    
                    let obj = UniDictObj()
                    obj.langTo = transSelection.rawValue
                    obj.eng = eng.capitalizingFirstLetter()
                    obj.translation = translation.capitalizingFirstLetter()
                    if isPhrase {
                        obj.lessonNum = lessonNum.count == 0 ? nil : Int(lessonNum)
                    }
                    obj.audioUrl = audioUrl.count == 0 ? nil : audioUrl
                    obj.isWord = isWord
                    obj.isPhrase = isPhrase
                    
                    switch viewType {
                    case .createFrom:
                        fallthrough
                    case .add:
                        RealmWrapper.shared.addTranslation(obj: obj)
                    case .modify:
                        RealmWrapper.shared.modify(key: id, withValues: obj)
                    }
                    
                    GlobalDialog.Close()
                }
                .disabled(isWord == false && isPhrase == false)
            }
        }
        .frame(minWidth: 350)
        .padding(20)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.focus = .f1
                self.keyboardFocusControlsSubscription()
            }
        }
    }
}


private extension AddTranslationView {
    func keyboardFocusControlsSubscription() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            guard focus != nil else { return nil }
            
            switch aEvent.keyCode {
            case 125: // down arrow
                focusNextField()
            case 126: // up arrow
                focusPreviousField()
            default:
                break
            }
            
            return aEvent
        }
    }
    
    enum Field: Int, CaseIterable {
        case f1, f2, f3, f4
    }
    
    enum ViewType: String {
        case add = "Add"
        case modify = "Modify"
        case createFrom = "Add word"
    }
    
    func focusPreviousField() {
        focus = focus.map {
            Field(rawValue: $0.rawValue - 1) ?? Field.allCases.last!
        }
    }
    
    func focusNextField() {
        focus = focus.map {
            Field(rawValue: $0.rawValue + 1) ?? Field.allCases.first!
        }
    }
}
