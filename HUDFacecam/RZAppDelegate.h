//
//  RZAppDelegate.h
//  HUDFacecam
//
//  Created by Nick Beeuwsaert on 6/5/14.
//  Copyright (c) 2014 Nick Beeuwsaert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "RZCamView.h"
@interface RZAppDelegate : NSObject <NSApplicationDelegate> {
    AVCaptureSession *audioLoopbackSession;
    
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet RZCamView *camOutput;
@property (assign) IBOutlet NSView *settingsOverlay;
@property (assign) IBOutlet NSPopUpButton *inputDevices;
@property (assign) IBOutlet NSPopUpButton *outputDevices;
@property (assign) IBOutlet NSButton *audioButton;

- (IBAction)toggleAudio:(id)sender;

@end
