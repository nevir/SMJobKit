//
//  AppDelegate.m
//  SampleApplication
//
//  Created by Ian MacLeod on 7/29/12.
//  Copyright (c) 2012 Ian MacLeod. All rights reserved.
//

#import "AppDelegate.h"

#import "SampleService.h"

@implementation AppDelegate
@synthesize outputTextView = _outputTextView;
@synthesize bundledVersionLabel = _bundledVersionLabel;
@synthesize installedVersionLabel = _installedVersionLabel;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [self updateStatus];
}

- (IBAction)installService:(id)sender
{
  NSError* error;
  // In order to test out SMJobKit,
  // SampleApplication is trying to install a new
  // helper tool.  Type your password to allow this.
  if (![SampleService installWithPrompt:@"In order to test out SMJobKit," error:&error])
  {
    [self appendMessage:error];
  }
  else
  {
    [self appendMessage:@"Successfully installed SampleService"];
  }
  
  [self updateStatus];
}

- (IBAction)uninstallService:(id)sender
{
  NSError* error;
  // In order to test out SMJobKit,
  // SampleApplication is trying to install a new
  // helper tool.  Type your password to allow this.
  if (![SampleService uninstallWithPrompt:@"In order to test out SMJobKit," error:&error])
  {
    [self appendMessage:error];
  }
  else
  {
    [self appendMessage:@"Successfully uninstalled SampleService"];
  }
  
  [self updateStatus];
}

- (void) updateStatus
{
  NSString* version = [SampleService bundledVersion];
  [self.bundledVersionLabel setTitleWithMnemonic:(version) ? version : @"Unknown Version"];
  
  version = [SampleService installedVersion];
  [self.installedVersionLabel setTitleWithMnemonic:(version) ? version : @"Not Installed"];
  
  [[SampleService checkForProblems] enumerateObjectsUsingBlock:^(NSError* error, NSUInteger i, BOOL *stop) {
    [self appendMessage:error];
  }];
}

- (void) appendMessage:(id)message
{
  self.outputTextView.string = [self.outputTextView.string stringByAppendingFormat:@"%@\n", message];
}

@end
