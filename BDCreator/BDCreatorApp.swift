import SwiftUI

@main
struct BDCreatorApp: App {
    @State var model = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(model: $model)
        }
    }
}
