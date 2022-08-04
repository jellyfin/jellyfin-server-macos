//
//  AlertWindow.swift
//  Jellyfin Server
//
//  Created by Ethan Pippin on 8/3/22.
//  Copyright © 2022 Jellyfin. All rights reserved.
//

import AppKit

class AlertWindow: NSWindow {
    
    convenience init(text: String) {
        let storyboard = NSStoryboard(name: "AlertViewController", bundle: nil)
        let alertViewController = storyboard.instantiateController(withIdentifier: "AlertViewController") as! AlertViewController
        
        self.init(contentViewController: alertViewController)
        
        alertViewController.errorLabel.stringValue = text
        
        styleMask.remove(.fullScreen)
        styleMask.remove(.miniaturizable)
        styleMask.remove(.resizable)
        titlebarAppearsTransparent = true
        title = ""
        level = .floating
    }
}
