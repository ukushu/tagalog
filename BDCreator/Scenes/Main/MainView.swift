import SwiftUI
import AppCore

struct MainView: View {
    @ObservedObject var model = MainViewModel.shared
    
    var body: some View {
        VStack {
            TabView {
                CurrentBdList()
                    .tabItem { Label("BD list", systemImage: "list.dash") }
                
                DetailsView()
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
            HSplitView {
                List (model.translations, id: \.self, selection: $model.selection) { obj in
                    HStack(alignment: .center) {
                        Text("\(obj.lessonNum?.description ?? "_" )  ")
                        Text("\(obj.langTo)")
                        
                        AudioPlayerView(audioUrl: obj.audioUrl)
                        
//                        if obj.audioUrl == nil {
//                            Space(35, .h)
//                        } else {
//                            Text.sfSymbol("speaker.wave.2")
//                        }
                        
                        Text("\(obj.translation)")
                    }
                    .makeFullyIntaractable()
                    .contextMenu {
                        Button("Edit") {
                            model.modify(obj: obj)
                        }
                        
                        Button("Finder: local Audio") {
                            guard let url = obj.audioUrl,
                                  let audioUrl = URL(string: url)
                            else { return }
                            
                            let destinationUrl = URL.BDCreateHome.appendingPathComponent(audioUrl.lastPathComponent)
                            
                            destinationUrl.FS.showInFinder()
                        }
                        
                        Button("Clean Audio Cache") {
                            _ = URL.BDCreateHome.FS.delete()
                        }
                        
                        Divider()
                        
                        Button("Delete") {
                            model.delete(translation: obj)
                        }
                    }
//                    .onTapGesture {
//                        model.selection = [obj]
//                    }
//                    .highPriorityGesture(
//                        TapGesture(count:2) .onEnded({ model.modify(obj: obj) })
//                    )
                }
                
                if model.selection.count == 1 {
                    PhraseDisplayerView(model: model.selection)
                }
            }
            
            FiltersPanel()
        }
    }
    
    func FiltersPanel() -> some View {
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
            
            Toggle("Hide words", isOn: $model.filterHideWords)
            
            Space()
            
            Button("+") {
                let dlg = SheetDialogType.view(view: AnyView(AddTranslationView()))
                
                GlobalDialog.Open(view: dlg)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 5) )
        }
    }
}

// Issues
extension MainView {
    func DetailsView() -> some View {
        Text("Issues")
    }
}

fileprivate extension MainViewModel {
    func modify(obj: UniDictObj) {
        let dlg = SheetDialogType.view(view: AnyView(AddTranslationView(obj: obj) ))
        
        GlobalDialog.Open(view: dlg)
    }
}

extension URL {
    static var BDCreateHome: URL {
        let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BDCreator")
        
        folderURL.FS.makeSureDirExist()
        
        return folderURL
    }
}
