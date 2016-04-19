//
//  EnterTabBarController.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/25/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterTabBarController.h"
#import "EnterInfoViewController.h"
#import "EnterNavigationController.h"
#import "EnterMessageViewController.h"
#import "EnterMonitorViewController.h"

@interface EnterTabBarController ()
@property (nonatomic, strong) EnterInfoViewController *infoViewController;
@property (nonatomic, strong) EnterMonitorViewController *monitorViewController;

@property (nonatomic, strong) EnterNavigationController *infoNavigationController;
@property (nonatomic, strong) EnterNavigationController *monitorNavigationController;
@end

@implementation EnterTabBarController

#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.viewControllers = @[self.infoNavigationController, self.monitorNavigationController];
  }
  
  return self;
}

#pragma mark - lifecyle

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tabBar.barStyle = UIBarStyleBlack;
  self.tabBar.barTintColor = [UIColor blackColor];
}

#pragma mark - accessor

- (EnterInfoViewController *)infoViewController
{
  if (!_infoViewController) {
    _infoViewController = [[EnterInfoViewController alloc] init];
  }
  
  return _infoViewController;
}

- (EnterMonitorViewController *)monitorViewController
{
  if (!_monitorViewController) {
    _monitorViewController = [[EnterMonitorViewController alloc] init];
  }
  
  return _monitorViewController;
}

- (EnterNavigationController *)infoNavigationController
{
  if (!_infoNavigationController) {
    _infoNavigationController = [[EnterNavigationController alloc] initWithRootViewController:self.infoViewController];
    _infoNavigationController.tabBarItem.title = @"Lightning Info";
  }
  
  return _infoNavigationController;
}

- (EnterNavigationController *)monitorNavigationController
{
  if (!_monitorNavigationController) {
    _monitorNavigationController = [[EnterNavigationController alloc] initWithRootViewController:self.monitorViewController];
    _monitorNavigationController.tabBarItem.title = @"Monitoring";
  }
  
  return _monitorNavigationController;
}

@end
