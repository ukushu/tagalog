import Foundation
import SwiftUI
import LangLearnCore

struct LanguageSelector: View {
    let text: LocalizedStringKey
    
    let translations = {
        var trans = LLLanguage.allCases
        trans.remove(at: 0)
        
        return trans
    }()
    
    @Binding var sel: LLLanguage
    
    var body: some View {
        Picker(text, selection: $sel) {
            ForEach(translations, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.menu)
    }
}
