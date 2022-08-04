//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import AppKit

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var launchAtLoginToggle: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func launchWebUISelected(_ sender: Any) {
        ActionManager.launchWebUI()
    }
    
    @IBAction func showLogsSelected(_ sender: Any) {
        ActionManager.showLogs()
    }
    
    @IBAction func aboutSelected(_ sender: Any) {
        ActionManager.launchAbout()
    }
}
