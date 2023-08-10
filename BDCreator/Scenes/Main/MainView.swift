import SwiftUI
import AppCore

struct MainView: View {
    @ObservedObject var model = MainViewModel.shared
    
    var body: some View {
        VStack {
            Button("+") {
                let dlg = SheetDialogType.view(view: AnyView(AddTranslationView()))
                
                GlobalDialog.Open(view: dlg)
            }
            
            List (model.translations, id: \.self.id, selection: $model.selection) { obj in
                HStack(alignment: .center) {
                    Text("\(obj.eng )")
                    Text(" => ")
                    Text("\(obj.translation)")
                }
            }
        }
        .sheet(sheet: model.dialog )
        .padding()
    }
}
