#import "XGSyncthing.h"

// How long we wait for one event poll
#define EVENT_TIMEOUT 60.0

@interface XGSyncthing()

@property (nonatomic, strong) NSXMLParser *configParser;
@property (nonatomic, strong) NSMutableArray<NSString *> *parsing;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation XGSyncthing {}

@synthesize URI = _URI;
@synthesize ApiKey = _apiKey;






- (BOOL)loadConfigurationFromXML
{
    NSError* error;
    NSURL *supURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                           inDomain:NSUserDomainMask
                                                  appropriateForURL:nil
                                                             create:NO
                                                              error:&error];
    NSURL* configUrl = [supURL URLByAppendingPathComponent:@"Syncthing/config.xml"];
    _parsing = [[NSMutableArray alloc] init];
    _configParser = [[NSXMLParser alloc] initWithContentsOfURL:configUrl];
    [_configParser setDelegate:self];
    return [_configParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    [_parsing addObject:elementName];
    NSString *keyPath = [_parsing componentsJoinedByString:@"."];

    if ([keyPath isEqualToString:@"configuration.gui"]) {
        if ([[[attributeDict objectForKey:@"tls"] lowercaseString] isEqualToString:@"true"]) {
            _URI = @"https://";
        } else {
            _URI = @"http://";
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [_parsing removeLastObject];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *keyPath = [_parsing componentsJoinedByString:@"."];

    if ([keyPath isEqualToString:@"configuration.gui.apikey"]) {
        _apiKey = string;
    } else if  ([keyPath isEqualToString:@"configuration.gui.address"]) {
        _URI = [_URI stringByAppendingString:string];
    }
}

@end
