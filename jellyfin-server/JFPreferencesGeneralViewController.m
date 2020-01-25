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


@end
