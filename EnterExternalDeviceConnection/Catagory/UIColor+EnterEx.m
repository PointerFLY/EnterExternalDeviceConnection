//
//  UIColor+EnterEx.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/29/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "UIColor+EnterEx.h"

@implementation UIColor (EnterEx)


+ (UIColor *)colorWithHex:(NSUInteger)rgbValue alpha:(CGFloat)alpha
{
  return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                         green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                          blue:((float)(rgbValue & 0xFF))/255.0
                         alpha:alpha];
}

+ (UIColor *)colorWithHex:(NSUInteger)rgbValue
{
  return [self colorWithHex:rgbValue alpha:1.0];
}


@end
