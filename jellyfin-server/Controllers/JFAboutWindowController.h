//
//  JFAboutWindowWindowController.h
//  Originally STAboutWindowWindowController.h from syncthing-macos
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JFAboutWindowController : NSWindowController

@property (weak) IBOutlet NSImageView *appImageView;
@property (weak) IBOutlet NSTextField *appNameLabel;
@property (weak) IBOutlet NSTextField *appVersionLabel;
@property (weak) IBOutlet NSTextField *appHomepageURL;

@end
