//
//  RZAppDelegate.m
//  HUDFacecam
//
//  Created by Nick Beeuwsaert on 6/5/14.
//  Copyright (c) 2014 Nick Beeuwsaert. All rights reserved.
//

#import "RZAppDelegate.h"

#define WINDOW_WIDTH 480
#define WINDOW_MIN_WIDTH 150

@implementation RZAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //[[[self settingsOverlay] animator]setAlphaValue:0];
    [[self camOutput]start];
    //[self repopulateInputDevices];
    
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways|NSTrackingInVisibleRect owner:self userInfo:nil];
    [[self settingsOverlay] addTrackingArea:trackingArea];
    [[self window] setLevel:kCGMainMenuWindowLevel-1];
    
    [[self window] setCollectionBehavior:NSWindowCollectionBehaviorStationary|NSWindowCollectionBehaviorCanJoinAllSpaces|NSWindowCollectionBehaviorFullScreenAuxiliary];
    
    
    //Create a capture session for audio loopback(this will be different from the
    // Video capture so we can pause just the audio)...
    audioLoopbackSession = [[AVCaptureSession alloc] init];
    
    NSError *err;
    AVCaptureDeviceInput *audio = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error: &err];
    if(!audio){
        NSLog(@"Error initializing audio: %@", [err localizedDescription]);
    }
    if([audioLoopbackSession canAddInput:audio]){
        [audioLoopbackSession addInput:audio];
    }
    //Create a audio output
    AVCaptureAudioPreviewOutput *audioOut = [[AVCaptureAudioPreviewOutput alloc] init];
    [audioOut setVolume:0.5];
    
    
    if([audioLoopbackSession canAddOutput:audioOut]){
        [audioLoopbackSession addOutput:audioOut];
    }
    //NSLog(@"%d", [[self window] contentView] setAspect)
    //[self startAudio];
    
    //Hurray for reading the documentation!
    [[self window] setContentAspectRatio:[[self camOutput] previewSize]];
    [[self window] setMinSize:NSMakeSize(WINDOW_MIN_WIDTH, WINDOW_MIN_WIDTH * [[self camOutput] aspectRatio])];
    

    [[self window] setContentSize:NSMakeSize(WINDOW_WIDTH, WINDOW_WIDTH*[[self camOutput] aspectRatio])];

}
- (IBAction)toggleAudio:(id)sender {
    if([audioLoopbackSession isRunning]){
        [self stopAudio];
    }else{
        [self startAudio];
    }
}
- (void)startAudio {
    [audioLoopbackSession startRunning];
}
- (void)stopAudio {
    [audioLoopbackSession stopRunning];
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}
- (void)mouseEntered:(NSEvent*)evt {
    [[[self settingsOverlay] animator]setAlphaValue:1];
}
- (void)mouseExited:(NSEvent*)evt {
    [[[self settingsOverlay] animator]setAlphaValue:0];
}
- (void) repopulateInputDevices {
    /*[[self inputDevices] removeAllItems];
    [AVCaptureOutput ]
    NSArray *captureDevices = [AVCaptureDe devicesWithMediaType:AVMediaTypeAudio];
    for(AVCaptureDevice *device in captureDevices){
        [[self inputDevices] addItemWithTitle:[device localizedName]];
    }*/
}
- (void) repopulateOutputDevices {
    [[self inputDevices] removeAllItems];
    NSArray *captureDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    for(AVCaptureDevice *device in captureDevices){
        [[self inputDevices] addItemWithTitle:[device localizedName]];
    }
}
@end
