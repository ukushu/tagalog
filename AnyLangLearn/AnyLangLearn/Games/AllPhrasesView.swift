import Foundation
import SwiftUI
import AppCore
import MoreSwiftUI

struct AllPhrasesView: View {
    @ObservedObject var model = MainViewModel.shared
    
    let origs: [String] = ["a1","b1","c1","d","5","6"]
    
    let word1 = "asdf"
    let word2 = "fdsa"
    
    var body: some View {
        HSplitView {
            List(model.translations, selection: $model.selection) { obj in
                Text(obj.translation)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .frame(minWidth: 200)
            
            ScrollView {
                HStack {
                    VStack {
                        Text("Hello world")
                        Text("World hello")
                        
                        Space(10)
                        
                        Text("\(word1) - \(word2)")
                        Text("\(word1) - \(word2)")
                        Text("\(word1) - \(word2)")
                        Text("\(word1) - \(word2)")
                        Text("\(word1) - \(word2)")
                        Text("\(word1) - \(word2)")
                        Text("\(word1) - \(word2)")
                    }
                    .padding()
                    
                    Space()
                }
            }
            .frame(minWidth: 200)
        }
    }
}
