//
//  NSDate+EnterEx.h
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/12/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (EnterEx)

/**
 *  get currentTime with formatted string
 *
 *  @return time string formatted as "hh:mm:ss"
 */
+ (NSString *)currentTimeString_HMS;

@end
