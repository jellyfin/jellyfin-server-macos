//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import AppKit

class PreferencesWindow: NSWindow {
    
    convenience init() {
        let storyboard = NSStoryboard(name: "PreferencesViewController", bundle: nil)
        let preferencesViewController = storyboard.instantiateController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
        
        self.init(contentViewController: preferencesViewController)
        
        styleMask.remove(.fullScreen)
        styleMask.remove(.miniaturizable)
        styleMask.remove(.resizable)
        titlebarAppearsTransparent = true
        title = ""
        level = .floating
    }
}
