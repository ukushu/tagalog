import SwiftUI

struct MainView: View {
    @Binding var model: MainViewModel
    
    var body: some View {
        VStack {
            AddTranslationView()
            
            List (model.translations, id: \.self.id, selection: $model.selection) { obj in
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
