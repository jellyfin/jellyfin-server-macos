//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2022 Jellyfin & Jellyfin Contributors
//

import AppKit
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    private var windowController = NSWindowController(window: nil)
    private var jellyfinProcess = Process()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
        
        createAppFolder()
        startJellyfinTask()
        createStatusBarMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        jellyfinProcess.terminate()
        jellyfinProcess.waitUntilExit()
    }
    
    private func createAppFolder() {
        // Old contents were stored in ~/.local/share
        // Move to ~/Library/Application Support/Jellyfin
        if directoryExists(path: localShareJellyfinFolder.path) {
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: localShareJellyfinFolder.path)
                
                for contentName in contents {
                    let oldPath = localShareJellyfinFolder.appendingPathComponent(contentName)
                    let newPath = applicationSupportJellyfinFolder.appendingPathComponent(contentName)
                    try FileManager.default.moveItem(atPath: oldPath.path,
                                                     toPath: newPath.path)
                }
                
                try FileManager.default.removeItem(atPath: localShareJellyfinFolder.path)
            } catch {
                present(alert: "Jellyfin Server was unable to properly migrate old directories.")
            }
        }
        
        if !directoryExists(path: applicationSupportJellyfinFolder.path) {
            do {
                try FileManager.default.createDirectory(atPath: applicationSupportJellyfinFolder.path,
                                                        withIntermediateDirectories: true)
            } catch {
                present(alert: "Jellyfin Server was unable to properly create necessary directories.")
            }
        }
    }
    
    private func startJellyfinTask() {
        let jellyfinPath = Bundle.main.path(forAuxiliaryExecutable: "jellyfin")
        let webUIPath = Bundle.main.resourceURL!.appendingPathComponent("jellyfin-web").path
        
        guard let jellyfinPath = jellyfinPath else {
            present(alert: "Jellyfin Server was unable to start underlying jellyfin task.")
            return
        }
        
        jellyfinProcess.launchPath = jellyfinPath
        jellyfinProcess.arguments = ["--webdir", webUIPath, "--cache", applicationSupportJellyfinFolder.path]
        
        do {
            try jellyfinProcess.run()
        } catch {
            present(alert: "Jellyfin Server was unable to start underlying jellyfin process.")
        }
    }

    private func createStatusBarMenu() {
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Launch", action: #selector(launchWebUI), keyEquivalent: "l")
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
