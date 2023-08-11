import SwiftUI
import AppCore

struct MainView: View {
    @ObservedObject var model = MainViewModel.shared
    
    var body: some View {
        VStack {
            TabView {
                CurrentBdList()
                    .tabItem { Label("BD list", systemImage: "list.dash") }
                
                IssuesView()
                    .tabItem { Label("Issues", systemImage: "list.dash") }
            }
        }
        .sheet(sheet: model.dialog )
        .padding()
    }
}

// CurrentBdList
extension MainView {
    func CurrentBdList() -> some View {
        VStack {
            List (model.translations, id: \.self.id, selection: $model.selection) { obj in
                HStack(alignment: .center) {
                    Text("\(obj.lessonNum?.description ?? "_" ) | ")
                    Text("\(obj.langTo) | ")
                    
                    Text("\(obj.eng )")
                    Text(" => ")
                    Text("\(obj.translation)")
                }
                .contextMenu {
                    Button("Delete") {
                        model.delete(translation: obj)
                    }
                }
            }
            
            HStack {
                Text("Filters: ")
                
                LanguageSelector(text: "To lang:", sel: $model.filterLanguage)
                    .frame(maxWidth: 150)
                
                Picker("Lesson:", selection: $model.filterLessonNum) {
                    ForEach(model.allLessonsNumbers, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 100)
                
                
                Space()
                
                Button("+") {
                    let dlg = SheetDialogType.view(view: AnyView(AddTranslationView()))
                    
                    GlobalDialog.Open(view: dlg)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 5) )
            }
        }
    }
}

// Issues
extension MainView {
    func IssuesView() -> some View {
        Text("Issues")
    }
}

