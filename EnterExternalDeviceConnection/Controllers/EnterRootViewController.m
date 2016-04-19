//
//  EnterRootViewController.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/25/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterRootViewController.h"
#import "EnterTabBarController.h"

@interface EnterRootViewController ()
@property (nonatomic, strong) EnterTabBarController *tabBarController;
@end

@implementation EnterRootViewController

#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
  };
  
  return self;
}

#pragma mark - lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view addSubview:self.tabBarController.view];
}

#pragma mark - accessor

- (EnterTabBarController *)tabBarController
{
  if (!_tabBarController) {
    _tabBarController = [[EnterTabBarController alloc] init];
  }
  
  return _tabBarController;
}

@end
