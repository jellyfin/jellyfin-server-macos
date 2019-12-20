#import "STApplication.h"
#import "STLoginItem.h"
#import "jellyfin_server_macos-Swift.h"


@interface STAppDelegate ()

@property (nonatomic, strong, readwrite) NSStatusItem *statusItem;
@property (nonatomic, strong, readwrite) XGSyncthing *syncthing;
@property (nonatomic, strong, readwrite) NSString *executable;
@property (nonatomic, strong, readwrite) DaemonProcess *process;
@property (strong) STPreferencesWindowController *preferencesWindow;
@property (strong) STAboutWindowController *aboutWindow;

@end

@implementation STAppDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
    _syncthing = [[XGSyncthing alloc] init];

    [self applicationLoadConfiguration];

    _process = [[DaemonProcess alloc] initWithPath:_executable delegate:self];
    [_process launch];

    
}


- (void) applicationWillTerminate:(NSNotification *)aNotification {
    [_process terminate];
}

- (void) awakeFromNib {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.menu = _Menu;

   [self updateStatusIcon:@"StatusIconNotify"];
}

// TODO: move to STConfiguration class
- (void)applicationLoadConfiguration {
    static int configLoadAttempt = 1;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    _executable = [defaults stringForKey:@"Executable"];
    if (!_executable) {
        // We store the server and runtime files in ~/Library/Application Support/Jellyfin/server by default
        _executable = [[self applicationSupportDirectoryFor:@"jellyfin-server/server"] stringByAppendingPathComponent:@"jellyfin"];
        [defaults setValue:_executable forKey:@"Executable"];
    }

    NSError *error;
    if (![self ensureExecutableAt:_executable error:&error]) {
        // Fail :(
        // TODO(jb): We should show a proper error dialog here.
        NSLog(@"Failed to prepare binary: %@", [error localizedDescription]);
        return;
    }

    _syncthing.URI = [defaults stringForKey:@"URI"];
    _syncthing.ApiKey = [defaults stringForKey:@"ApiKey"];

    // If no values are set, read from XML and store in defaults
    if (!_syncthing.URI.length && !_syncthing.ApiKey.length) {
        BOOL success = [_syncthing loadConfigurationFromXML];

        // If XML doesn't exist or is invalid, retry after delay
        if (!success && configLoadAttempt <= 3) {
            configLoadAttempt++;
            [self performSelector:@selector(applicationLoadConfiguration) withObject:self afterDelay:5.0];
            return;
        }

        [defaults setObject:_syncthing.URI forKey:@"URI"];
        [defaults setObject:_syncthing.ApiKey forKey:@"ApiKey"];
    }

    if (!_syncthing.URI) {
        _syncthing.URI = @"http://localhost:8096";
        [defaults setObject:_syncthing.URI forKey:@"URI"];
    }

    if (!_syncthing.ApiKey) {
        _syncthing.ApiKey = @"";
        [defaults setObject:_syncthing.ApiKey forKey:@"ApiKey"];
    }

    if (![defaults objectForKey:@"StartAtLogin"]) {
        [defaults setBool:[STLoginItem wasAppAddedAsLoginItem] forKey:@"StartAtLogin"];
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

    NSString *parent = [path stringByDeletingLastPathComponent];
    if (![manager fileExistsAtPath:path]) {
        // The directory to hold the binary doesn't exist. We must create it.
        if (![manager createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:error]) {
            return NO;
        }
    }

    // Copy the bundled executable to the desired location. Pass on return and error to the caller.
    NSString *bundled = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"jellyfin"];
    return [manager copyItemAtPath:bundled toPath:path error:error];
}

- (void) sendNotification:(NSString *)text {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Syncthing";
    notification.informativeText = text;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void) updateStatusIcon:(NSString *)icon {
    _statusItem.button.image = [NSImage imageNamed:@"StatusBarButtonImage"];
	[_statusItem.button.image setTemplate:YES];
}


- (IBAction) clickedOpen:(id)sender {
    NSURL *URL = [NSURL URLWithString:[_syncthing URI]];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}


-(void) menuWillOpen:(NSMenu *)menu {
}

- (IBAction) clickedQuit:(id)sender {
    
    [self updateStatusIcon:@"StatusIconNotify"];
    [_statusItem setToolTip:@""];
    _statusItem.menu = nil;

    [NSApp performSelector:@selector(terminate:) withObject:nil];
}


// TODO: need a more generic approach for opening windows
- (IBAction)clickedPreferences:(NSMenuItem *)sender {
    if (_preferencesWindow != nil) {
        [NSApp activateIgnoringOtherApps:YES];
        [_preferencesWindow.window makeKeyAndOrderFront:self];
        return;
    }

    _preferencesWindow = [[STPreferencesWindowController alloc] init];
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

    _aboutWindow = [[STAboutWindowController alloc] init];
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
