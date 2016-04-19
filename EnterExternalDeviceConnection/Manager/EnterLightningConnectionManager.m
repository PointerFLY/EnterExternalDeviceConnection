//
//  EnterLightningConnectionManager.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/21/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterLightningConnectionManager.h"
#import "EnterOrderQueue.h"
#import "EnterDataParser.h"
#import "AppDelegate.h"

NSString *const kEnterAccessoryDidConnectNotification = @"kEnterAccessoryDidConnectNotification";
NSString *const kEnterAccessoryDidDisconnectNotification = @"KEnterAccessoryDidDisconnectNotification";
NSString *const kEnterStreamDidOpenNotification = @"kEnterStreamDidOpenNotification";
NSString *const kEnterStreamDidCloseNotification = @"kEnterStreamDidCloseNotifcation";
NSString *const kEnterStreamDidOccurErrorNotification = @"kEnterStreamDidOccurErrorNotification";
NSString *const kEnterDidUpdateStatisticsNotification = @"kEnterDidUpdateStatisticsNotification";
NSString *const kEnterStreamCanWriteNotification = @"kEnterStreamCanWriteNotification";

NSString *const kEnterLightningProtocolString = @"com.enter.protocol";

NSUInteger const kEnterStreamMaxLength = 128;
float const kEnterSpeedRefreshInterval = 0.01;

@interface EnterLightningConnectionManager() <NSStreamDelegate>
@property (nonatomic, strong, readwrite) EASession *session;
@property (nonatomic, strong, readwrite) EAAccessory *accessory;
@property (nonatomic, assign, readwrite) NSUInteger receivingSpeed;
@property (nonatomic, assign, readwrite) NSUInteger packageCount;
@property (nonatomic, assign, readwrite) NSUInteger receivedSize;

@property (nonatomic, strong) EAAccessoryManager *accessoryManager;
@property (nonatomic, strong) NSOutputStream *outStream;
@end

@implementation EnterLightningConnectionManager

#pragma mark - init & dealloc

- (instancetype)init
{
  if (self = [super init])
  {
    _packageCount = 0;
    _receivedSize = 0;
    _receivingSpeed = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAccessoryDidConnectNotification:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:kEnterSpeedRefreshInterval target:self selector:@selector(refreshSpeed) userInfo:nil repeats:YES];
  }
  
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public

+ (EnterLightningConnectionManager *)manager
{
  static dispatch_once_t onceToken;
  static EnterLightningConnectionManager *__manager = nil;
  
  dispatch_once(&onceToken, ^() {
    __manager = [[EnterLightningConnectionManager alloc] init];
  });
  
  return __manager;
}

- (void)startMonitoring
{
  [self.accessoryManager registerForLocalNotifications];
  
   EnterLog(@"start monitoring");
}

- (void)stopMonitoring
{
  [self.accessoryManager unregisterForLocalNotifications];
  self.session = nil;
  self.accessory = nil;
  self.outStream = nil;
  
  [self resetStatistics];
  
   EnterLog(@"stop monitoring");
}

- (void)resetStatistics
{
  self.packageCount = 0;
  self.receivedSize = 0;
  self.receivingSpeed = 0;
}

#pragma mark - action

- (void)refreshSpeed
{
  static NSUInteger lastCount = 0;
  
  NSUInteger delta = self.packageCount - lastCount;
  self.receivingSpeed = (float)delta / kEnterSpeedRefreshInterval;
  
  lastCount = self.packageCount;

  [[NSNotificationCenter defaultCenter] postNotificationName:kEnterDidUpdateStatisticsNotification object:nil];
}

#pragma mark - private

- (EASession *)openSessionForProtocol:(NSString *)protocolString
{
  NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
  EASession *session = nil;
  
  for (EAAccessory *obj in accessories) {
    if ([[obj protocolStrings] containsObject:protocolString]) {
      self.accessory = obj;
      
      break;
    }
  }
  
  if (self.accessory) {
    session = [[EASession alloc] initWithAccessory:self.accessory
                                       forProtocol:protocolString];
    if (session) {
      [[NSNotificationCenter defaultCenter] postNotificationName:kEnterAccessoryDidConnectNotification object:nil];
      EnterLog(@"accessory did connect");

      [[session inputStream] setDelegate:self];
      [[session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                       forMode:NSDefaultRunLoopMode];
      [[session inputStream] open];
      
      [[session outputStream] setDelegate:self];
      [[session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                        forMode:NSDefaultRunLoopMode];
      [[session outputStream] open];
    }
  }
  
  return session;
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
  switch (eventCode)
  {
    case NSStreamEventHasBytesAvailable: {
      NSInputStream *inputStream = (NSInputStream *)aStream;
      [self processInputStream:inputStream];
      
      break;
    }
    case NSStreamEventHasSpaceAvailable: {
      self.outStream = (NSOutputStream *)aStream;
      EnterLog(@"stream has space available");
      
      break;
    }
    case NSStreamEventOpenCompleted: {
      [[NSNotificationCenter defaultCenter] postNotificationName:kEnterStreamDidOpenNotification object:nil];
      EnterLog(@"stream did open");
      
      break;
    }
    case NSStreamEventEndEncountered: {
      self.session = nil;
      self.accessory = nil;
      self.outStream = nil;
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kEnterStreamDidCloseNotification object:nil];
      [[NSNotificationCenter defaultCenter] postNotificationName:kEnterAccessoryDidDisconnectNotification object:nil];
      
      EnterLog(@"stream did close");
      EnterLog(@"accessory did disconnect");

      break;
    }
    case NSStreamEventErrorOccurred: {
      [[NSNotificationCenter defaultCenter] postNotificationName:kEnterStreamDidOccurErrorNotification object:nil];
      self.outStream = nil;
      EnterLog(@"stream error");
      
      break;
    }
    default: {
      break;
    }
  }
}

#pragma mark - action

- (void)handleAccessoryDidConnectNotification:(NSNotification *)notification
{
  self.session = [self openSessionForProtocol:kEnterLightningProtocolString];
}

#pragma mark - private

- (void)processInputStream:(NSInputStream *)stream
{
  Byte bytes[kEnterStreamMaxLength];
  NSInteger realLength = [stream read:bytes maxLength:kEnterStreamMaxLength];
  
  NSData *data = [NSData dataWithBytes:bytes length:kEnterStreamMaxLength];
  NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
  NSString *log = [NSString stringWithFormat:@"received content: %@", receivedString];
  EnterLog(log);

  self.receivedSize += realLength;
  self.packageCount++;
}

- (void)send:(Byte *)bytes
{
  [self.outStream write:bytes maxLength:kEnterStreamMaxLength];
  
  NSString *log = [NSString stringWithFormat:@"sent data: %@", [[NSString alloc] initWithBytes:bytes length:kEnterStreamMaxLength encoding:NSASCIIStringEncoding]];
  EnterLog(log);
}

#pragma mark - accessor

- (EAAccessoryManager *)accessoryManager
{
  return [EAAccessoryManager sharedAccessoryManager];
}

- (BOOL)connected
{
  return (self.accessory != nil);
}

- (BOOL)writable
{
  return (self.outStream != nil);
}

@end
