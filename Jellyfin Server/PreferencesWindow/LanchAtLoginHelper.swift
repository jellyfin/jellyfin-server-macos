//
// Jellyfin Server is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2024 Jellyfin & Jellyfin Contributors
//

import Foundation
import Combine
import ServiceManagement
import LaunchAtLogin

private let useLaunchAgentKey = "LaunchAtLogin__useLaunchAgent"

public enum LanchAtLoginHelper {
    public static let kvo = KVO()
    public static let observable = Observable()
    private static let _publisher = CurrentValueSubject<Bool, Never>(isEnabled)
    public static let publisher = _publisher.eraseToAnyPublisher()

    private static var useLaunchAgent: Bool {
        get {
            UserDefaults.standard.bool(forKey: useLaunchAgentKey)
        }
        set {
            // This should present on all normal macOS installs, if it does not, well, the user breaks the system
            guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
                exit(1)
            }
            let launchAgentsDirectory = libraryDirectory.appendingPathComponent("LaunchAgents")
            let agentFileURL = launchAgentsDirectory.appendingPathComponent("Jellyfin.Server.plist")

            // This will return true if the LaunchAgents folder is already created. This should be there as part of the standard installation.
            do {
                try FileManager.default.createDirectory(at: launchAgentsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                exit(1)
            }

            do {
                if newValue == true {
                    try getLaunchAgentPlist().write(to: agentFileURL, atomically: true, encoding: .utf8)
                } else {
                    if FileManager.default.fileExists(atPath: agentFileURL.path) {
                        try FileManager.default.removeItem(at: agentFileURL)
                    }
                }
                UserDefaults.standard.set(newValue, forKey: useLaunchAgentKey)
            } catch {
                print("Error writing LaunchAgent file: \(error)")
            }
        }
    }

    public static var isEnabled: Bool {
        get {
            if #available(macOS 13, *) {
                return LaunchAtLogin.isEnabled
            } else {
                return useLaunchAgent
            }
        }
        set {
            observable.objectWillChange.send()

            kvo.willChangeValue(for: \.isEnabled)

            if #available(macOS 13, *) {
                LaunchAtLogin.isEnabled = newValue
            } else {
                useLaunchAgent = newValue
            }

            kvo.didChangeValue(for: \.isEnabled)

            _publisher.send(newValue)
        }
    }

    public static func migrateIfNeeded() {
        // Run the upstream migration first, so that OS running on macOS 13+ with old mechanism is migrated
        LaunchAtLogin.migrateIfNeeded()

        // No custom migration needed on macOS 13+ and not using LaunchAgent
        // No custom migration needed on macOS 12 and using LaunchAgent
        let skipMigragtion: Bool = {
            if #available(macOS 13, *),
               !useLaunchAgent {
                return true
            }
            if #unavailable(macOS 13),
               useLaunchAgent {
                return true
            }
            return false
        }()

        guard
            !skipMigragtion,
            !LaunchAtLogin.isEnabled
        else {
            return
        }

        if #available(macOS 13, *) {
            useLaunchAgent = false
        } else {
            SMLoginItemSetEnabled("\(Bundle.main.bundleIdentifier!)-LaunchAtLoginHelper" as CFString, false)
        }
    }
}

extension LanchAtLoginHelper {
    public final class Observable: ObservableObject {
        public var isEnabled: Bool {
            get { LanchAtLoginHelper.isEnabled }
            set {
                LanchAtLoginHelper.isEnabled = newValue
            }
        }
    }
}

extension LanchAtLoginHelper {
    public final class KVO: NSObject {
        @objc dynamic public var isEnabled: Bool {
            get { LanchAtLoginHelper.isEnabled }
            set {
                LanchAtLoginHelper.isEnabled = newValue
            }
        }
    }
}

