//
//  RZCamView.h
//  HUDFacecam
//
//  Created by Nick Beeuwsaert on 6/5/14.
//  Copyright (c) 2014 Nick Beeuwsaert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface RZCamView : NSView {
    AVCaptureSession *session;
    NSView *output;
    AVCaptureVideoPreviewLayer *previewLayer;
    CMVideoDimensions dim;
    CAShapeLayer *mask;
}
- (AVCaptureVideoPreviewLayer*) previewLayer;
- (void) stop;
- (void) start;
- (float) aspectRatio;
- (NSSize) previewSize;
@end
