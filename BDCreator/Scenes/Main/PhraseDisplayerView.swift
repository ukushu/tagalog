import Foundation
import SwiftUI
import AppCore

struct PhraseDisplayerView: View {
    let model: UniDictObj
    
    let phrases: [String]
    
    @State var selection: Set<String>
    
    init(model: Set<UniDictObj>) {
        self.model = model.first!
        
        if model.first!.wordsUsed.count == 1 {
            self.phrases = [model.first!.translation]
        } else {
            self.phrases = [model.first!.translation].appending(contentsOf: model.first!.wordsUsed)
        }
        
        selection = [model.first!.translation]
    }
    
    var body: some View {
        VStack {
            VStack{
                HStack {
                    Text(model.eng)
                    Space()
                }
            }
            .padding()
            .frame(minHeight: 20)
            
            List (phrases, id: \.self, selection: $selection) { phrase in
                Text(phrase)
                    .fixedSize()
                    .contextMenu {
                        Button("Add this word") {
                            let obj = UniDictObj()
                            obj.isWord = true
                            obj.translation = phrase
                            
                            let dlg = SheetDialogType.view(view: AnyView(AddTranslationView(createFrom: obj)))
                            
                            GlobalDialog.Open(view: dlg)
                        }
                    }
            }
            .frame(minWidth: 300)
        }
    }
}
