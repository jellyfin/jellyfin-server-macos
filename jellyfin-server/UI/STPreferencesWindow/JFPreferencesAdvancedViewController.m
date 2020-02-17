//
//  JFPreferencesAdvancedViewController.m
//  Originally STPreferencesAdvancedViewController.m from syncthing-macos
//
//  Created by Jerry Jacobs on 04/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "JFPreferencesAdvancedViewController.h"

@interface JFPreferencesAdvancedViewController ()

@end

@implementation JFPreferencesAdvancedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id) init {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    return self;
}

- (IBAction)openAppFolder:(id)sender {
    NSString *configDir = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @"Library/Application Support/Jellyfin/server"];
    NSURL *folderURL = [NSURL fileURLWithPath: configDir];
    [[NSWorkspace sharedWorkspace] openURL:folderURL];
}

- (IBAction)openDataFolder:(id)sender {
    NSString *configDir = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".local/share/jellyfin/data"];
    NSURL *folderURL = [NSURL fileURLWithPath: configDir];
    [[NSWorkspace sharedWorkspace] openURL:folderURL];
}

- (IBAction)openLogFolder:(id)sender {
    NSString *configDir = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".local/share/jellyfin/log"];
    NSURL *folderURL = [NSURL fileURLWithPath: configDir];
    [[NSWorkspace sharedWorkspace] openURL:folderURL];
}

@end
