//
//  NSDate+EnterEx.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/12/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "NSDate+EnterEx.h"

@implementation NSDate (EnterEx)

+ (NSString *)currentTimeString_HMS
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"hh:mm:ss";
  NSString *dataTime = [formatter stringFromDate:[NSDate date]];
  
  return dataTime;
}

@end
