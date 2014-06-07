//
//  RZCamView.m
//  HUDFacecam
//
//  Created by Nick Beeuwsaert on 6/5/14.
//  Copyright (c) 2014 Nick Beeuwsaert. All rights reserved.
//

#import "RZCamView.h"

#define CORNER_RADIUS 6
@implementation RZCamView

- (void)awakeFromNib {
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetMedium];
    
    //Figuring out the dimensions of the capture device took me way too long to figure out how to do
    AVCaptureDevice *camera =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    dim = CMVideoFormatDescriptionGetDimensions([[camera activeFormat] formatDescription]);
    
    NSError *err = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&err];

    
    if(!input){
        session = nil;
        NSLog(@"Trouble with camera: %@!", [err localizedDescription]);
    }
    if([session canAddInput:input]){
        [session addInput:input];
    }
    
    //Create a preview..
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];

    [previewLayer setVideoGravity: AVLayerVideoGravityResizeAspect];
    //[self setLayer:previewLayer];
    [self setLayer:previewLayer];
    [self setWantsLayer:YES];
    
    mask = [[CAShapeLayer alloc]init];
    [[self layer] setMask: mask];
    [self updateMask];
    //[[self layer] setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
}
- (void) updateMask {
    //Not sure if freeing the path first is needed...
    CGPathRelease(mask.path);
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath, nil, 0, [self frame].size.height);
    CGPathAddLineToPoint(mutablePath, NULL, [self frame].size.width, [self frame].size.height);
    CGPathAddArcToPoint(mutablePath, nil, [self frame].size.width, 0,
                        0, 0, CORNER_RADIUS);
    CGPathAddArcToPoint(mutablePath, nil, 0, 0,
                        0, [self frame].size.height, CORNER_RADIUS);

    
    mask.path = CGPathCreateCopy(mutablePath);
    CGPathRelease(mutablePath);
}
-(void) setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    [self updateMask];
}
- (void) start {
    [session startRunning];
}
- (void) stop {
    [session stopRunning];
}
- (AVCaptureVideoPreviewLayer*) previewLayer {
    return previewLayer;
}
- (float)aspectRatio {
    return (float)dim.height / (float)dim.width;
}
- (NSSize)previewSize {
    return NSMakeSize(dim.width, dim.height);
}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self awakeFromNib];
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    // Drawing code here.
}

@end
