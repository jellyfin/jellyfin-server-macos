/**
 * Jellyfin-Server-macOS Objective-C client library
 */
#import <Foundation/Foundation.h>

@interface JellyfinMacOS : NSObject<NSXMLParserDelegate>

@property (nonatomic, copy) NSString *URI;

/**
 * Load configuration from XML file
 */
- (BOOL)loadConfigurationFromXML;

@end
