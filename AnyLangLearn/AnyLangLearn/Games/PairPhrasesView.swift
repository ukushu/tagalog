import Foundation
import SwiftUI
import Essentials

struct PairPhrasesView: View {
    @State var selected: [Pair] = []
    
    @State var pairs: [Pair] = [
        Pair(orig: "red", translate: "green"),
        Pair(orig: "green", translate: "blue"),
        Pair(orig: "blue", translate: "a1"),
        Pair(orig: "a1", translate: "b2"),
        Pair(orig: "b2", translate: "c3"),
        Pair(orig: "c3", translate: "red"),
    ]
    
    var body: some View {
        VStack {
            Button("Check my results") {
                
            }
            .padding()
            
            ScrollView(.vertical ) {
                ForEach(pairs, id: \.self) { pair in
                    PairView(isSelected: selected.contains(pair), pair: pair)
                        .onTapGesture {
                            withAnimation {
                                if selected.contains(pair) {
                                    selected.removeFirst(where: { $0 == pair})
                                } else {
                                    selected.append(pair)
                                }
                                
                                guard selected.count == 2 else { return }
                                
                                let idx1 = pairs.firstIndex(of: selected[0] )!
                                let idx2 = pairs.firstIndex(of: selected[1] )!
                                
                                let pair1 = Pair(orig: selected[0].orig, translate: selected[1].translate)
                                let pair2 = Pair(orig: selected[1].orig, translate: selected[0].translate)
                                
                                pairs[idx1] = pair1
                                pairs[idx2] = pair2
                                
                                selected = []
                            }
                        }
                }
            }
        }
    }
}

struct PairView: View {
    let isSelected: Bool
    var pair: Pair
    
    var body: some View {
        HStack(spacing: 2) {
            HStack(spacing: 0) {
                Spacer()
                Text(pair.orig)
            }
            .padding(3)
            .frame(width: 400) //window.width/2 - 15
            
            Text("->")
                .padding(EdgeInsets( vertical: 3))
            
            HStack(spacing: 0){
                Text(pair.translate)
                Spacer()
            }
            .padding(3)
            .background(isSelected ? .green.opacity(0.2) : .clear )
        }
        .makeFullyIntaractable()
    }
}

struct Pair: Hashable {
    let orig: String
    var translate: String
}
