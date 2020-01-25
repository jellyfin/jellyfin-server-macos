//
//  PreferencesWindowController.h
//  syncthing-mac
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JFPreferencesGeneralViewController;
@class JFPreferencesInfoViewController;
@class JFPreferencesAdvancedViewController;

@interface JFPreferencesWindowController : NSWindowController

@property (nonatomic, assign) NSViewController *currentViewController;

@property (nonatomic, strong) JFPreferencesGeneralViewController *generalView;
@property (nonatomic, strong) JFPreferencesInfoViewController *infoView;
@property (nonatomic, strong) JFPreferencesAdvancedViewController *advancedView;

- (IBAction) toolbarButtonClicked:(id)sender;

@end
