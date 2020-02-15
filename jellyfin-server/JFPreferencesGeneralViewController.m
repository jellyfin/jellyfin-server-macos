//
//  TestView.m
//  syncthing
//
//  Created by Jerry Jacobs on 02/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "JFPreferencesGeneralViewController.h"
#import "JFLoginItem.h"
#import "JellyfinMacOS.h"

@interface JFPreferencesGeneralViewController ()

@end

@implementation JFPreferencesGeneralViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateURIField];
    
}

- (id) init {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    return self;
}


- (IBAction)clickedStartAtLogin:(id)sender {
    [self updateStartAtLogin];
}

- (void) updateStartAtLogin {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"StartAtLogin"]) {
        if (![JFLoginItem wasAppAddedAsLoginItem])
            [JFLoginItem addAppAsLoginItem];
    } else {
        [JFLoginItem deleteAppFromLoginItem];
    }
}

- (void) updateURIField {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.Jellyfin_URI.stringValue = [defaults stringForKey:@"URI"];
}

- (IBAction)switched:(id)sender; {
    if (sender == self.AutoOpenWebUI)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.AutoOpenWebUI.isOn forKey:@"AutoOpenWebUI"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



@end
