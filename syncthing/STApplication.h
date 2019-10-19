//
//  AppDelegate.h
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "XGSyncthing.h"
#import "Controllers/STAboutWindowController.h"
#import "Controllers/STPreferencesWindowController.h"
#import "Jellyfin_Server-Swift.h"

//@interface STAppDelegate : NSObject <NSApplicationDelegate, STStatusMonitorDelegate, DaemonProcessDelegate>
@interface STAppDelegate : NSObject <NSApplicationDelegate, DaemonProcessDelegate>

@property (weak) IBOutlet NSMenu *Menu;
@property (nonatomic, readonly) NSStatusItem *statusItem;

@end
