//
// Jellyfin Server is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import Foundation

func isRunningFromApplicationFolder() -> Bool {
    let bundlePath = Bundle.main.bundlePath
    let applicationsPath = "/Applications/"
    return bundlePath.hasPrefix(applicationsPath)
}

func getLaunchAgentPlist() -> String {
    let identifier = Bundle.main.bundleIdentifier ?? "Jellyfin.Server"
    let path = Bundle.main.path(forAuxiliaryExecutable: "Jellyfin Server") ?? "/Applications/Jellyfin.app/Contents/MacOS/Jellyfin Server"
    let template = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>\(identifier)</string>
        <key>ProgramArguments</key>
        <array>
            <string>\(path)</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
</dict>
</plist>
"""
    return template
}

let localShareJellyfinFolder: URL = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".local/share/jellyfin")

let applicationSupportJellyfinFolder: URL = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent("/Library/Application Support/jellyfin")

func directoryExists(path: String) -> Bool {
    var isDirectory: ObjCBool = false
    return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
}

func getJellyfinNetworkConfig() -> (port: String, proto: String, subPath:String) {
    let configFile: URL = directoryExists(path: localShareJellyfinFolder.path)
        ? localShareJellyfinFolder.appendingPathComponent("config/network.xml")
        : applicationSupportJellyfinFolder.appendingPathComponent("config/network.xml")
    var httpPort = "8096"
    var httpsPort = "8920"
    var requireHttps = false
    var enableHttps = false
    var subPath = ""
    do {
        let config = try XMLDocument(contentsOf: configFile)
        try config.validate()
        if let rootElement = config.rootElement() {
            if let internalHttpPort = rootElement.elements(forName: "InternalHttpPort").first?.stringValue {
                httpPort = internalHttpPort
            }
            
            if let internalHttpsPort = rootElement.elements(forName: "InternalHttpsPort").first?.stringValue {
                httpsPort = internalHttpsPort
            }
            
            if let enableHttpsString = rootElement.elements(forName: "EnableHttps").first?.stringValue {
                enableHttps = (enableHttpsString as NSString).boolValue
            }
            
            if let requireHttpsString = rootElement.elements(forName: "RequireHttps").first?.stringValue {
                requireHttps = (requireHttpsString as NSString).boolValue
            }
            
            if let baseUrl = rootElement.elements(forName: "BaseUrl").first?.stringValue, !baseUrl.isEmpty {
                subPath = baseUrl
            }
        }
    } catch {
        print("Jellyfin Server config is invalid, using default values.")
    }
    
    if requireHttps && enableHttps {
        return (httpsPort, "https", subPath)
    } else {
        return (httpPort, "http", subPath)
    }
}
