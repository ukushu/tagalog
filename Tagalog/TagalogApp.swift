//
//  TagalogApp.swift
//  Tagalog
//
//  Created by UKS on 10.08.2023.
//

import SwiftUI

@main
struct TagalogApp: App {
    @State var model = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: $model)
        }
    }
}
