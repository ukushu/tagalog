import Foundation
import SwiftUI

enum Language: String, CaseIterable ,RawRepresentable {
    case English
    case Tagalog
    case Ukrainian
}

struct LanguageSelector: View {
    let text: LocalizedStringKey
    
    let translations = {
        var trans = Language.allCases
        trans.remove(at: 0)
        
        return trans
    }()
    
    @Binding var sel: Language
    
    var body: some View {
        Picker(text, selection: $sel) {
            ForEach(translations, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.menu)
    }
}
