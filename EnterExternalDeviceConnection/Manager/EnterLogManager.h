//
//  EnterLogManager.h
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/7/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterLogManager : NSObject

/**
 *  get log manager, singleton
 *
 *  @return defalut singleton manager
 */
+ (EnterLogManager *)manager;
/**
 *  clear logs, that is, move all content of the log file
 */
- (void)clearLog;
/**
 *  read log from the log file
 *
 *  @return the whole log file content string
 */
- (NSString *)readLog;
/**
 *  add a new log
 *
 *  @param aString a new log
 */
- (void)addLog:(NSString *)aString;

@end
