//
//  EnterFileManager.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/7/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterFileManager.h"

@implementation EnterFileManager

+ (NSString *)documentDirectory
{
  return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

@end
