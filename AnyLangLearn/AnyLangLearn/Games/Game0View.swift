import Foundation
import SwiftUI
import AppCore

struct Game0View: View {
    let origs: [String] = ["a1","b1","c1","d","5","6"]
    
    @State var selection: Set<String> = []
    
    let word1 = "asdf"
    let word2 = "fdsa"
    
    var body: some View {
        HSplitView {
            List(origs, id:\.self, selection: $selection) { text in
                Text(text)
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
