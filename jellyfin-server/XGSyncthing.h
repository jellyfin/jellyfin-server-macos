/**
 * Syncthing Objective-C client library
 */
#import <Foundation/Foundation.h>

@interface XGSyncthing : NSObject<NSXMLParserDelegate>

@property (nonatomic, copy) NSString *URI;
@property (nonatomic, copy) NSString *ApiKey;

/**
 * Load configuration from XML file
 */
- (BOOL)loadConfigurationFromXML;

@end
