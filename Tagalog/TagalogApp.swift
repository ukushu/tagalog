import SwiftUI

@main
struct TagalogApp: App {
    @State var model = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(model: $model)
        }
    }
}
