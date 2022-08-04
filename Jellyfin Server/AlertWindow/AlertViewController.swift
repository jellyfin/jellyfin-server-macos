//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import AppKit

class AlertViewController: NSViewController {
    
    @IBOutlet weak var errorLabel: NSTextField!
    
    @IBAction func exitSelected(_ sender: Any) {
        view.window?.windowController?.close()
        ActionManager.terminateWithError()
    }
}
