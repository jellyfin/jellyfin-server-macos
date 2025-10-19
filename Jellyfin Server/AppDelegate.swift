//
// Jellyfin Server is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import AppKit
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var windowController = NSWindowController(window: nil)
    private var jellyfinProcess = Process()

    func applicationDidFinishLaunching(_: Notification) {
        if !isRunningFromApplicationFolder() {
            present(alert: "Jellyfin Server is not running from the Applications folder. Exiting...")
        }
        statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
        LanchAtLoginHelper.migrateIfNeeded()

        startJellyfinTask()
        createStatusBarMenu()
    }

    func applicationWillTerminate(_: Notification) {
        jellyfinProcess.terminate()
        jellyfinProcess.waitUntilExit()
    }

    private func startJellyfinTask() {
        let jellyfinPath = Bundle.main.path(forAuxiliaryExecutable: "jellyfin")
        let ffmpegPath = Bundle.main.path(forAuxiliaryExecutable: "ffmpeg")
        let webUIPath = Bundle.main.resourceURL!.appendingPathComponent("jellyfin-web").path

        guard let jellyfinPath = jellyfinPath else {
            present(alert: "Jellyfin Server was unable to start underlying jellyfin task.")
            return
        }
        
        guard let ffmpegPath = ffmpegPath else {
            present(alert: "Jellyfin Server was unable to find bundled ffmpeg.")
            return
        }

        jellyfinProcess.launchPath = jellyfinPath
        jellyfinProcess.arguments = ["--webdir", webUIPath, "--ffmpeg", ffmpegPath, "--datadir"]
        
        if directoryExists(path: localShareJellyfinFolder.path) {
            jellyfinProcess.arguments?.append(localShareJellyfinFolder.path)
        } else {
            jellyfinProcess.arguments?.append(applicationSupportJellyfinFolder.path)
        }

        do {
            try jellyfinProcess.run()
        } catch {
            present(alert: "Jellyfin Server was unable to start underlying jellyfin process.")
        }
    }

    private func createStatusBarMenu() {
        let menu = NSMenu()

        menu.addItem(withTitle: "Launch", action: #selector(launchWebUI), keyEquivalent: "l")

        if (isNativeClientInstalled()) {
            menu.addItem(withTitle: "Launch App", action: #selector(launchNativeApp), keyEquivalent: "a")
        }

        menu.addItem(withTitle: "Show Logs", action: #selector(showLogs), keyEquivalent: "d")
        menu.addItem(withTitle: "Restart", action: #selector(restart), keyEquivalent: "r")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Preferences", action: #selector(launchPreferences), keyEquivalent: ",")
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc private func launchWebUI() {
        ActionManager.launchWebUI()
    }

    @objc private func launchNativeApp() {
        NSWorkspace.shared.openApplication(at: nativePlayerURL!, configuration: NSWorkspace.OpenConfiguration())
    }

    @objc private func showLogs() {
        ActionManager.showLogs()
    }

    @objc private func restart() {
        ActionManager.restart()
    }

    @objc private func launchPreferences() {
        let window = PreferencesWindow()

        windowController.window = window
        windowController.showWindow(self)
    }

    private func present(alert: String) {
        let alertWindow = AlertWindow(text: alert)

        windowController.window = alertWindow
        windowController.showWindow(self)
    }
}
