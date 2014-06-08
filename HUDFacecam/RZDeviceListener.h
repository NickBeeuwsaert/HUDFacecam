//
//  RZDeviceListener.h
//  HUDFacecam
//
//  Created by Nick Beeuwsaert on 6/7/14.
//  Copyright (c) 2014 Nick Beeuwsaert. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RZDeviceListenerDelegate<NSObject>
@optional
-(void)stupidSelector;
@end

@interface RZDeviceListener : NSObject {
    //id delegate;
}
@property (nonatomic, weak) id<RZDeviceListenerDelegate> delegate;
- (void)updateDeviceList;
- (void) test;
@end
