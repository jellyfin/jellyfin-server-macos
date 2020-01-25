//
//  STConfiguration.m
//  syncthing
//
//  Created by Jerry Jacobs on 04/10/2016.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "JFConfiguration.h"
#import "JellyfinMacOS.h"

@interface JFConfiguration()

@property JellyfinMacOS *st;

@end

@implementation JFConfiguration

NSString *const defaultHost       = @"http://localhost:8096";
NSString *defaultExecutable;

- (id) init {
    defaultExecutable = [NSString stringWithFormat:@"%@/%@",
                         [[NSBundle mainBundle] resourcePath],
                         @"jellyfin/server"];
    return self;
}

- (void)saveConfig {
    
}

- (void)loadConfig {
    
}

@end
