import Foundation
import SwiftUI

struct AddTranslationView: View {
    let model = MainViewModel()
    
    @State var text: String = ""
    @State var text2: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Eng:       ")
                TextField("Eng", text: $text)
            }
            
            HStack {
                Text("Tagalog:")
                TextField("Tagalog", text: $text2)
            }
            
            Button("Append") {
                RealmWrapper.shared.addTranslation(eng: text, to: .Tagalog, toText: text2)
                model.refresh()
            }
        }
    }
}
