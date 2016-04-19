//
//  AppDelegate.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/21/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "AppDelegate.h"
#import "EnterLightningConnectionManager.h"
#import "EnterRootViewController.h"
#import "EnterLogManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  EnterRootViewController *rootViewController = [[EnterRootViewController alloc] init];
  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  _window.rootViewController = rootViewController;
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  
  EnterLightningConnectionManager *manager = [EnterLightningConnectionManager manager];
  [manager startMonitoring];
  
  [[EnterLogManager manager] clearLog];
  
  [self setCommonProperties];
  
  return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
  
}

- (UIViewController *)rootViewController
{
  return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)setCommonProperties
{
  [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.9]];
  [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

@end
