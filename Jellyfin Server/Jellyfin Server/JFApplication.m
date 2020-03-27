#import "JFApplication.h"
#import "JFLoginItem.h"
#import "Jellyfin_Server-swift.h"


@interface STAppDelegate ()

@property (nonatomic, strong, readwrite) NSStatusItem *statusItem;
@property (nonatomic, strong, readwrite) NSString *URI;
@property (nonatomic, strong, readwrite) NSString *executable;
@property (nonatomic, strong, readwrite) DaemonProcess *process;
@property (strong) JFPreferencesWindowController *preferencesWindow;
@property (strong) JFAboutWindowController *aboutWindow;

@end

@implementation STAppDelegate

 
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [self applicationLoadConfiguration];

    _process = [[DaemonProcess alloc] initWithPath:_executable delegate:self];
    [_process launch];

    
}

- (void) awakeFromNib {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.menu = _Menu;
    _statusItem.button.image = [NSImage imageNamed:@"StatusBarButtonImage"];
}

- (void)applicationLoadConfiguration {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Watch out! This line gets data from the NSUserDefaults (defaults read org.jellyfin.server.macos)
    // If you're updating this area, make sure you run "defaults delete org.jellyfin.server.macos" first!
    _executable = [defaults stringForKey:@"Executable"];
    if (!_executable) {
        // We store the server and runtime files in ~/Library/Application Support/Jellyfin/server by default
        // Then the appended path component is the actual executable to run
        _executable = [[self applicationSupportDirectoryFor:@"jellyfin"] stringByAppendingPathComponent:@"server/jellyfin"];
        [defaults setValue:_executable forKey:@"Executable"];
    }

    NSError *error;
    if (![self ensureExecutableAt:_executable error:&error]) {
        // Fail :(
        // TODO(jb): We should show a proper error dialog here.
        NSLog(@"Failed to prepare binary: %@", [error localizedDescription]);
        return;
    }

    _URI = [defaults stringForKey:@"URI"];


    if (!_URI) {
        // if not already saved once, gets the machine host name and saves it for launching the web UI
        NSString * currentHost = [[NSHost currentHost] name];
        NSString * urlString = [NSString stringWithFormat:@"http://%@:8096", currentHost];
        _URI = urlString;
        [defaults setObject:_URI forKey:@"URI"];
    }

    if (![defaults objectForKey:@"StartAtLogin"]) {
        [defaults setBool:[JFLoginItem wasAppAddedAsLoginItem] forKey:@"StartAtLogin"];
    }
    
    if (![defaults objectForKey:@"AutoOpenWebUI"]) {
        [defaults setBool:true forKey:@"AutoOpenWebUI"];
    }
    
}

- (NSString*)applicationSupportDirectoryFor:(NSString*)application {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        return [[paths firstObject] stringByAppendingPathComponent:application];
    
}

- (BOOL)ensureExecutableAt:(NSString*)path error:(NSError* _Nullable*)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        // The executable exists. Nothing for us to do.
        return YES;
    }
// TODO FIX THIS
    NSString *parent = [[path stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
    if (![manager fileExistsAtPath:path]) {
        // The directory to hold the binary doesn't exist. We must create it.
        if (![manager createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:error]) {
            return NO;
        }
    }
// TODO FIX THIS
    // Copy the bundled executable to the desired location. Pass on return and error to the caller.
    // I have created a mess of trying to ensure this is at the right path - Anthony, Feb 2020
    NSString *bundled = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"server"];
    NSString *destpath = [parent stringByAppendingPathComponent:@"server"];
    return [manager copyItemAtPath:bundled toPath:destpath error:error];
}

- (IBAction) clickedOpen:(id)sender {
    NSURL *URL = [NSURL URLWithString:_URI];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}
- (IBAction) clickedViewLogs:(id)sender {
    NSString *configDir = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".local/share/jellyfin/log"];
    NSURL *folderURL = [NSURL fileURLWithPath: configDir];
    [[NSWorkspace sharedWorkspace] openURL:folderURL];
}


-(void) menuWillOpen:(NSMenu *)menu {
}

- (IBAction) clickedQuit:(id)sender {
    [NSApp performSelector:@selector(terminate:) withObject:nil];
}

- (IBAction)clickedRestart:(NSMenuItem *)sender {
    [_process restart];
}

// TODO: need a more generic approach for opening windows
- (IBAction)clickedPreferences:(NSMenuItem *)sender {
    if (_preferencesWindow != nil) {
        [NSApp activateIgnoringOtherApps:YES];
        [_preferencesWindow.window makeKeyAndOrderFront:self];
        return;
    }

    _preferencesWindow = [[JFPreferencesWindowController alloc] init];
    [_preferencesWindow showWindow:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:[_preferencesWindow window]];
}

- (IBAction)clickedAbout:(NSMenuItem *)sender {
    if (_aboutWindow != nil) {
        [NSApp activateIgnoringOtherApps:YES];
        [_aboutWindow.window makeKeyAndOrderFront:self];
        return;
    }

    _aboutWindow = [[JFAboutWindowController alloc] init];
    [_aboutWindow showWindow:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(aboutWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:[_aboutWindow window]];
}


// TODO: need a more generic approach for closing windows
- (void)aboutWillClose:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowWillCloseNotification
                                                  object:[_aboutWindow window]];
    _aboutWindow = nil;
}

- (void)preferencesWillClose:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowWillCloseNotification
                                                  object:[_preferencesWindow window]];
    _preferencesWindow = nil;
}

- (void)process:(DaemonProcess *)_ isRunning:(BOOL)isRunning {

}

@end
