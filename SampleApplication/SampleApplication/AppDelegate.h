//
//  AppDelegate.h
//  SampleApplication
//
//  Created by Ian MacLeod on 7/29/12.
//  Copyright (c) 2012 Ian MacLeod. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow* window;
@property (strong) IBOutlet NSTextView* outputTextView;
@property (weak) IBOutlet NSTextField* bundledVersionLabel;
@property (weak) IBOutlet NSTextField* installedVersionLabel;

- (IBAction)installService:(id)sender;
- (IBAction)uninstallService:(id)sender;

- (void) updateStatus;
- (void) appendMessage:(id)message;

@end
