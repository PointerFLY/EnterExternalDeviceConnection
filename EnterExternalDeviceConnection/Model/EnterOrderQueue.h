//
//  EnterOrderQueue.h
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/8/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @deprecated This class is currently deprecated
 */
@interface EnterOrderQueue : NSObject

/**
 *  Simple deque the topest bytes
 *
 *  @return the topest order
 */
- (Byte *)deque;
/**
 *  Push back a bytes
 *
 *  @param order in form of array or its pointer
 */
- (void)enque:(Byte *)order;

/**
 *  indicate the queue is empty or not
 */
@property (nonatomic, assign) BOOL isEmpty;

@end
