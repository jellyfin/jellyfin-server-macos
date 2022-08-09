//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Foundation

let localShareJellyfinFolder: URL = {
    FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".local/share/jellyfin")
}()

let applicationSupportJellyfinFolder: URL = {
    FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("/Library/Application Support/jellyfin")
}()

func directoryExists(path: String) -> Bool {
    var isDirectory: ObjCBool = false
    return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
}
