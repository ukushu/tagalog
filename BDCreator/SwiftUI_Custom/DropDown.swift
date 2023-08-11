import Foundation
import SwiftUI

struct DropDown<Data>: View where Data : RandomAccessCollection,
                                  Data.Element : StringProtocol,
//                                      Data.Element : RawRepresentable,
//                                      Data.Element.RawValue : StringProtocol,
                                      Data.Element : Hashable{
    let text: LocalizedStringKey
    let items: Data
    @Binding var sel: Data.Element?
    
    var body: some View {
        Picker(text, selection: $sel) {
            ForEach(items, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.menu)
    }
}
