#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow* window;

@property (strong) IBOutlet NSTextView* outputTextView;
@property (weak) IBOutlet NSTextField* bundledVersionLabel;
@property (weak) IBOutlet NSTextField* installedVersionLabel;

- (IBAction) installService:(id)sender;

- (void) updateStatus;
- (void) appendMessage:(id)message;

@end
