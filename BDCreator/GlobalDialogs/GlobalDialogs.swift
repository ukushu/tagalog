import Foundation
import AppCore
import AsyncNinja

public class GlobalDialog {
    public static func Open(view: SheetDialogType) {
        AppCore.signals
            .send( signal: Signal.OpenDialog(dlg: view) )
    }
    
    public static func Close() {
        AppCore.signals
            .send(signal: Signal.CloseDialog() )
    }
}
