import Foundation
import MoreSwiftUI
import AsyncNinja
import AppCore

public class GlobalDialog {
    public static func Open(view: MoreSwiftUI.SheetDialogType) {
        AppCore.signals
            .send( signal: Signal.OpenDialog(dlg: view) )
    }
    
    public static func Close() {
        AppCore.signals
            .send(signal: Signal.CloseDialog() )
    }
}
