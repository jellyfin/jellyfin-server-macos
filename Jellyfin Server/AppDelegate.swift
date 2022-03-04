//
//  AppDelegate.swift
//  Server
//
//  Created by Anthony Lavado on 2019-06-26.
//  Copyright © 2019 Anthony Lavado. All rights reserved.
//
/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
let bundle = Bundle.main
var task = Process()

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        
        let fileManager = FileManager.default
        let home = FileManager.default.homeDirectoryForCurrentUser
        let appFolder = home.appendingPathComponent(".local/share")
        var isDirectory: ObjCBool = false
        let folderExists = fileManager.fileExists(atPath: appFolder.path,
                                      isDirectory: &isDirectory)
        if !folderExists || !isDirectory.boolValue {
          do {

            try fileManager.createDirectory(at: appFolder,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
          } catch {
            // TODO: Add system dialog and stop here. Provide instructions at a link.
            print("Could not create cache folder. Reason: \(error)")
            }
        }
        
        let path = Bundle.main.path(forAuxiliaryExecutable: "jellyfin")
        let webui = Bundle.main.resourceURL!.appendingPathComponent("jellyfin-web").path
        
        task.launchPath = path
        task.arguments = ["--webdir", webui]
        
        do {
            try  task.run()
        } catch {
            // TODO: Add system dialog and stop here. Provide instructions at a link.
            print("Could not launch Jellyfin. Reason: \(error)")
        }
        
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      task.terminate()
    task.waitUntilExit()
        
    }
    
    @objc func launchWebUI(sender: Any?) {
        NSWorkspace.shared.open(NSURL(string: "http://localhost:8096")! as URL)
    }
   
    @objc func showLogs(sender: Any?){
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: "/Users/\(NSUserName())/.local/share/jellyfin/log")
    }

    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Launch Web UI", action: #selector(launchWebUI(sender:)), keyEquivalent: "l"))
        menu.addItem(NSMenuItem(title: "Show Logs", action: #selector(showLogs(sender:)), keyEquivalent: "d"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Jellyfin Server", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
}

