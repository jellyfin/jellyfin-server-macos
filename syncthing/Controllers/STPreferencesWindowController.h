//
//  PreferencesWindowController.h
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STPreferencesGeneralViewController;
@class STPreferencesInfoViewController;
@class STPreferencesAdvancedViewController;

@interface STPreferencesWindowController : NSWindowController

@property (nonatomic, assign) NSViewController *currentViewController;

@property (nonatomic, strong) STPreferencesGeneralViewController *generalView;
@property (nonatomic, strong) STPreferencesInfoViewController *infoView;
@property (nonatomic, strong) STPreferencesAdvancedViewController *advancedView;

- (IBAction) toolbarButtonClicked:(id)sender;

@end
