//
//  TestView.m
//  syncthing
//
//  Created by Jerry Jacobs on 02/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "STPreferencesGeneralViewController.h"
#import "STLoginItem.h"
#import "JellyfinMacOS.h"

@interface STPreferencesGeneralViewController ()

@end

@implementation STPreferencesGeneralViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
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
        if (![STLoginItem wasAppAddedAsLoginItem])
            [STLoginItem addAppAsLoginItem];
    } else {
        [STLoginItem deleteAppFromLoginItem];
    }
}


@end
