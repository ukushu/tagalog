import Foundation
import SwiftUI

struct AddTranslationView: View {
    @State var transSelection = Language.Tagalog
    
    @State var text: String = ""
    @State var text2: String = ""
    @State var audioUrl: String = ""
    
    
    @State var lessonNum: String = "9999"
    
    @FocusState private var focus: Field?
    
    @State var isWord: Bool = false
    @State var isPhrase: Bool = false
    
    var body: some View {
        VStack {
            LanguageSelector(text: "Language to: ", sel: $transSelection)
            
            HStack{
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
            
            HStack {
                Text("Eng:         ")
                TextField("Eng", text: $text)
                    .focused($focus, equals: .f2)
            }
            
            HStack {
                Text("Translate:")
                TextField("Translate", text: $text2)
                    .focused($focus, equals: .f3)
            }
            
            HStack {
                Text("Audio:      ")
                TextField("Audio", text: $audioUrl)
                    .focused($focus, equals: .f4)
            }
            
            HStack {
                Toggle(isOn: $isWord) { Text("Is word") }
                
                Toggle(isOn: $isPhrase) { Text("Is phrase") }
            }
            
            HStack {
                Button("Cancel", role: .cancel) {
                    GlobalDialog.Close()
                }
                
                Button("Append", role: .destructive) {
                    guard text.count > 0 && text2.count > 0 else { return }
                    
                    let obj = UniDictObj()
                    obj.langTo = transSelection.rawValue
                    obj.eng = text
                    obj.translation = text2
                    obj.lessonNum = lessonNum.count == 0 ? nil : Int(lessonNum)
                    obj.audioUrl = audioUrl.count == 0 ? nil : audioUrl
                    obj.isWord = isWord
                    obj.isPhrase = isPhrase
                    
                    RealmWrapper.shared.addTranslation(obj: obj)
                    
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
