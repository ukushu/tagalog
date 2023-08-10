import Foundation
import SwiftUI

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack {
            Text(error.localizedDescription )
            
            Button("OK") {
                GlobalDialog.Close()
            }
        }
    }
}
