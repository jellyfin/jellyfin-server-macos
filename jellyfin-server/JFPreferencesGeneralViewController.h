//
//  TestView.h
//  syncthing
//
//  Created by Jerry Jacobs on 02/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JFPreferencesGeneralViewController : NSViewController

@property (weak) IBOutlet NSTextField *Jellyfin_URI;
@property (weak) IBOutlet NSButton *StartAtLogin;
@property (weak) IBOutlet NSButton *AutoOpenWebUI;


@end
