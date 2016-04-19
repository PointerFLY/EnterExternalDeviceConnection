//
//  EnterLogManager.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/7/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterLogManager.h"
#import "EnterFileManager.h"

#define kEnterLogFileName @"enter.log"

@interface EnterLogManager()
@property (nonatomic, strong) NSFileHandle *handler;
@property (nonatomic, strong) NSString *logFilePath;
@end

@implementation EnterLogManager

#pragma mark - public

+ (EnterLogManager *)manager
{
  static EnterLogManager *__manager = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^() {
    __manager = [[EnterLogManager alloc] init];
  });
  
  return __manager;
}

- (void)dealloc
{
  [self.handler closeFile];
}

- (NSString *)readLog
{
  NSData *data = [[NSFileManager defaultManager] contentsAtPath:self.logFilePath];
  NSString *log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
  return log;
}

- (void)clearLog
{
  [self.handler truncateFileAtOffset:0];
  [self.handler synchronizeFile];
}

- (void)addLog:(NSString *)aString
{
  NSString *dataString = [NSDate currentTimeString_HMS];
  NSString *str = [NSString stringWithFormat:@"%@  %@\n", dataString, aString];
  [self.handler writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
  [self.handler synchronizeFile];
}

#pragma mark - private

#pragma mark - accessor

- (NSFileHandle *)handler
{
  if (!_handler) {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.logFilePath]) {
      [[NSFileManager defaultManager] createFileAtPath:self.logFilePath contents:nil attributes:nil];
    }
    
    _handler = [NSFileHandle fileHandleForUpdatingAtPath:self.logFilePath];
  }
  
  return _handler;
}

- (NSString *)logFilePath
{
  return [[EnterFileManager documentDirectory] stringByAppendingPathComponent:kEnterLogFileName];
}

@end
