//
//  EnterLightningConnectionManager.h
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/21/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

// The accessory did connect to app and session is established
FOUNDATION_EXTERN NSString *const kEnterAccessoryDidConnectNotification;
// The accessory is not connected to app regardless of whether it's still connected to the iphone
FOUNDATION_EXTERN NSString *const kEnterAccessoryDidDisconnectNotification;
FOUNDATION_EXTERN NSString *const kEnterStreamDidOpenNotification;
FOUNDATION_EXTERN NSString *const kEnterStreamDidCloseNotification;
FOUNDATION_EXTERN NSString *const kEnterStreamDidOccurErrorNotification;
FOUNDATION_EXTERN NSString *const kEnterDidUpdateStatisticsNotification;
// The accessory is now available to receive data
FOUNDATION_EXTERN NSString *const kEnterStreamCanWriteNotification;

FOUNDATION_EXTERN float const kEnterSpeedRefreshInterval;
FOUNDATION_EXTERN NSUInteger const kEnterStreamMaxLength;

@interface EnterLightningConnectionManager : NSObject

/**
 *  Current session established with the connected accessory
 */
@property (nonatomic, strong, readonly) EASession *session;
/**
 *  Current connected accessory
 */
@property (nonatomic, strong, readonly) EAAccessory *accessory;
/**
 *  Whether there's a accessory connection
 */
@property (nonatomic, assign, readonly) BOOL connected;
/**
 *  Whether the accessory is read to receive data
 */
@property (nonatomic, assign, readonly) BOOL writable;

// Statistics
@property (nonatomic, assign, readonly) NSUInteger receivingSpeed;
@property (nonatomic, assign, readonly) NSUInteger packageCount;
@property (nonatomic, assign, readonly) NSUInteger receivedSize;

/**
 *  Get the default singleton manager, there should be only one lightning connection manager
 *  during the app lifecycle.
 *
 *  @return singleton
 */
+ (EnterLightningConnectionManager *)manager;

/**
 *  The manager start monitoring
 */
- (void)startMonitoring;
/**
 *  The manager stop monitoring
 */
- (void)stopMonitoring;
/**
 *  Add new order to queue
 *
 *  @param bytes a order
 */
- (void)send:(Byte *)bytes;
/**
 *  reset statistics values
 */
- (void)resetStatistics;

@end
