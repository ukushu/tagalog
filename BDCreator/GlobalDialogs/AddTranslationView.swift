import Foundation
import SwiftUI

struct AddTranslationView: View {
    let translations = {
        var trans = Language.allCases
        trans.remove(at: 0)
        
        return trans
    }()
    
    @State var transSelection = Language.Tagalog
    
    @State var text: String = ""
    @State var text2: String = ""
    
    @State var lessonNum: String = "9999"
    
    var body: some View {
        VStack {
            Picker("Language to: ", selection: $transSelection) {
                ForEach(translations, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.menu)
            
            HStack{
                Text("Lesson # :")
                
                TextField("", text: $lessonNum)
                    .onChange(of: lessonNum) { _ in
                        let tmp = lessonNum.filter{ $0.isNumber }
                        
                        guard lessonNum == lessonNum else { return }
                        
                        lessonNum = tmp
                    }
                
                Button("-") {
                    lessonNum = ""
                }
            }
            
            HStack {
                Text("Eng:         ")
                TextField("Eng", text: $text)
            }
            
            HStack {
                Text("Translate:")
                TextField("Translate", text: $text2)
            }
            
            HStack {
                Button("Cancel", role: .cancel) {
                    GlobalDialog.Close()
                }
                
                Button("Append", role: .destructive) {
                    guard text.count > 0 && text2.count > 0 else { return }
                    
                    RealmWrapper.shared.addTranslation(eng: text, to: transSelection, toText: text2)
                    
                    GlobalDialog.Close()
                }
            }
        }
        .frame(minWidth: 350)
        .padding(20)
    }
}
