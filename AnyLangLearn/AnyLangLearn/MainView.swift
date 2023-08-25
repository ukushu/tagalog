import SwiftUI
import AppCore

struct MainView: View {
    var body: some View {
        VStack {
            FilterPanel()
            
            AllPhrasesView()
//            PairPhrasesView()
        }
    }
}

struct FilterPanel: View {
    @ObservedObject var model = MainViewModel.shared
    
    var body: some View {
        HStack {
            Text("Native Language")
            
            Text("Language to Learn DD")
            
            Text("Lesson DD")
            
            Text("Mode") // List of videogames and razgovornik
        }
    }
}
