import SwiftUI

struct ContentView: View {
    @Binding var model: ContentViewModel
    
    var body: some View {
        VStack {
            AddTranslationView()
            
            List (model.translations, id: \.self) { obj in
                HStack(alignment: .center) {
                    Text("\(obj.eng )")
                    Text(" => ")
                    Text("\(obj.translation)")
                }
            }
            
        }
        .padding()
    }
}

struct AddTranslationView: View {
    let model = ContentViewModel()
    
    @State var text: String = ""
    @State var text2: String = ""
    
    var body: some View {
        VStack {
            Text("Eng:")
            TextField("Eng", text: $text)
            
            Text("Tagal:")
            TextField("Tagalog", text: $text2)
            
            Button("Append") {
                if RealmWrapper.shared.addTranslation(eng: text, to: .Tagalog, toText: text2)
                {
                    model.refresh()
                }
            }
        }
    }
}


class ContentViewModel: ObservableObject {
    let realmWrap = RealmWrapper()
    @Published var translations: [UniDictObj] = []
    
    init() {
        refresh()
    }
    
    func refresh() {
        translations = realmWrap.translations
            .map{ $0 }
    }
}


//let lesson1: [String] = [
//    "Hello",
//    "Goodbye",
//    "Good morning",
//    "Good afternoon",
//    "Good night",
//    "What is your name?",
//    "My name is ___",
//    "See you later",
//    "See you tomorrow"
//]
//
//let lesson2: [String] = [
//    "Sorry, I did not hear you",
//    "Where do you live?",
//    "Where are you from?",
//    "How are you?",
//    "Fine, thank you",
//    "And you?",
//    "Nice to meet you",
//    "Nice to see you",
//    "Have a nice day"
//]

//class Translator {
//    let lengFrom: Language
//    let lengTo: Language
//
//    init(lengFrom: Language, lengTo: Language) {
//        self.lengFrom = lengFrom
//        self.lengTo = lengTo
//    }
//}
