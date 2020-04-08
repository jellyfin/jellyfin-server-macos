//
//  JFApplication.h
//  Originally AppDelegate.h from syncthing-macos
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Controllers/JFAboutWindowController.h"
#import "Controllers/JFPreferencesWindowController.h"
#import "Jellyfin_Server-swift.h"

@interface STAppDelegate : NSObject <NSApplicationDelegate, DaemonProcessDelegate>

@property (weak) IBOutlet NSMenu *Menu;
@property (nonatomic, readonly) NSStatusItem *statusItem;

@end