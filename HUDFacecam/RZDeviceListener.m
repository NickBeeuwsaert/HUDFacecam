//
//  RZDeviceListener.m
//  HUDFacecam
//
//  Created by Nick Beeuwsaert on 6/7/14.
//  Copyright (c) 2014 Nick Beeuwsaert. All rights reserved.
//
#import <CoreAudio/CoreAudio.h>
#import "RZDeviceListener.h"
/**
 * YO
 * THIS FILE IS NOT BY ANY MEANS PRODUCTION READY
 * DON'T TRUST WHAT YOU SEE
 **/
static OSStatus getAudioDevices(Ptr *devices, UInt16 *numDevices){
    OSStatus err = noErr;
    UInt32 dataSize;
    
    //Find out all the audio devices
    AudioObjectPropertyAddress theAddress = { kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster };
    
    err = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &theAddress, 0, NULL, &dataSize);
    if(err != noErr)return err;
    
    *numDevices = dataSize / sizeof(AudioObjectID);
    if(*numDevices){
        fprintf(stderr, "Oh nooo, no audio objects\n");
        return err;
    }
    
    if(*devices!=NULL) free(*devices);
    
    *devices = (Ptr)malloc(dataSize);
    
    memset(*devices, 0, dataSize);
    err = AudioObjectGetPropertyData(kAudioObjectSystemObject, &theAddress, 0, NULL, &dataSize, (void*)*devices);
    
    return err;
}
OSStatus RZPropertyListener(AudioObjectID inObjectID, UInt32 numAddresses, const AudioObjectPropertyAddress inAddresses[], void *data){
    
    RZDeviceListener *deviceListener = (RZDeviceListener *)CFBridgingRelease(data);
    for(UInt32 i = 0; i < numAddresses; i++){
        switch(inAddresses[i].mSelector){
            case kAudioHardwarePropertyDevices:
                [deviceListener performSelectorOnMainThread:@selector(updateDeviceList) withObject:nil waitUntilDone:NO];
                NSLog(@"YOU GOT MAIL YAAAY");
            break;
        }
    }
    return noErr;
}
@implementation RZDeviceListener
- (id)init {
    self = [super init];
    if(self){
        // install kAudioHardwarePropertyDevices notification listener
        AudioObjectPropertyAddress theAddress = { kAudioHardwarePropertyDevices,
            kAudioObjectPropertyScopeGlobal,
            kAudioObjectPropertyElementMaster };
        
        AudioObjectAddPropertyListener(kAudioObjectSystemObject, &theAddress, RZPropertyListener, (__bridge void*)(self));
        NSLog(@"Me: %p", self);
    }
    return self;
}
-(void)test {
    if([[self delegate] respondsToSelector:@selector(stupidSelector)]){
        [[self delegate] stupidSelector];
    }
}
-(void)updateDeviceList {
    NSLog(@"Hello!");
}
@end
