import SwiftUI
import AppCore

struct MainView: View {
    @ObservedObject var model = MainViewModel.shared
    
    var body: some View {
        VStack {
            TabView {
                CurrentBdList()
                    .tabItem { Label("BD list", systemImage: "list.dash") }
                
                Text("Issues")
                    .tabItem { Label("Issues", systemImage: "list.dash") }
            }
        }
        .sheet(sheet: model.dialog )
        .padding()
    }
    
    
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
