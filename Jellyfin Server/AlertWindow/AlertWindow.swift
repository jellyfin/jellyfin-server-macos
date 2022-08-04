//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import AppKit

class AlertWindow: NSWindow {
    
    convenience init(text: String) {
        let storyboard = NSStoryboard(name: "AlertViewController", bundle: nil)
        let alertViewController = storyboard.instantiateController(withIdentifier: "AlertViewController") as! AlertViewController
        
        self.init(contentViewController: alertViewController)
        
        alertViewController.errorLabel.stringValue = text
        
        styleMask.remove(.fullScreen)
        styleMask.remove(.miniaturizable)
        styleMask.remove(.resizable)
        titlebarAppearsTransparent = true
        title = ""
        level = .floating
    }
}
