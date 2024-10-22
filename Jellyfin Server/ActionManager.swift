//
// Jellyfin Server is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import AppKit
import Foundation

enum ActionManager {
    static func launchWebUI() {
        let (port, proto, subPath) = getJellyfinNetworkConfig()
        NSWorkspace.shared.open(.init(string: "\(proto)://localhost:\(port)\(subPath)")!)
    }

    static func showLogs() {
        let logFolder = directoryExists(path: localShareJellyfinFolder.path) ? localShareJellyfinFolder.appendingPathComponent("/log") : applicationSupportJellyfinFolder.appendingPathComponent("/log")
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: logFolder.path)
    }

    static func launchAbout() {
        NSWorkspace.shared.open(.init(string: "https://jellyfin.org")!)
    }

    static func restart() {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "sleep 2; open \"\(Bundle.main.bundlePath)\""]
        task.launch()

        NSApp.terminate(self)
        exit(0)
    }

    static func terminateWithError() {
        NSApp.terminate(self)
        exit(1)
    }
}
