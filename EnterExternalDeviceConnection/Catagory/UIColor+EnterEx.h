//
//  UIColor+EnterEx.h
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/29/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (EnterEx)

/**
 *  get a color with hex integer like 0x2200FF
 *
 *  @param rgbValue hex integer between 0x000000 - 0xFFFFFF
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(NSUInteger)rgbValue;
/**
 *  get a color with hex integer and indicated alpha
 *
 *  @param rgbValue hex integer between 0x000000 - 0xFFFFFF
 *  @param alpha   0.0 - 1.0
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(NSUInteger)rgbValue alpha:(CGFloat)alpha;


@end
