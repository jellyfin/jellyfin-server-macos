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
//        startJellyfinTask()
        createStatusBarMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        print("app will terminate received")
        jellyfinProcess.terminate()
        jellyfinProcess.waitUntilExit()
    }
    
    private func createAppFolder() {
        var isDirectory: ObjCBool = false
        let shareFolderExists = FileManager.default.fileExists(atPath: ActionManager.shareFolder.path,
                                                               isDirectory: &isDirectory)
        
        if !shareFolderExists || !isDirectory.boolValue {
            do {
                try FileManager.default.createDirectory(at: ActionManager.shareFolder, withIntermediateDirectories: true)
            } catch {
                let alertWindow = AlertWindow(text: "Jellyfin Server was unable to properly create expected directories.")
                
                windowController.window = alertWindow
                windowController.showWindow(self)
            }
        }
    }
    
    private func startJellyfinTask() {
        let jellyfinPath = Bundle.main.path(forAuxiliaryExecutable: "jellyfin")
        let webUIPath = Bundle.main.resourceURL!.appendingPathComponent("jellyfin-web").path
        
        guard let jellyfinPath = jellyfinPath else {
            let alertWindow = AlertWindow(text: "Jellyfin Server was unable to start underlying jellyfin task.")
            
            windowController.window = alertWindow
            windowController.showWindow(self)
            
            return
        }
        
        jellyfinProcess.launchPath = jellyfinPath
        jellyfinProcess.arguments = ["--webdir", webUIPath]
        
        do {
            try jellyfinProcess.run()
        } catch {
            let alertWindow = AlertWindow(text: "Jellyfin Server was unable to start underlying jellyfin process.")
            
            windowController.window = alertWindow
            windowController.showWindow(self)
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
        ActionManager.launchAbout()
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
}
