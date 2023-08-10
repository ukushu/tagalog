import Foundation
import SwiftUI

struct AddTranslationView: View {
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
            
            HStack {
                Button("Cancel", role: .cancel) {
                    GlobalDialog.Close()
                }
                
                Button("Append", role: .destructive) {
                    RealmWrapper.shared.addTranslation(eng: text, to: .Tagalog, toText: text2)
                    
                    GlobalDialog.Close()
                }
            }
        }
        .frame(minWidth: 350)
        .padding(20)
    }
}
