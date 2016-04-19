//
//  EnterNavigationController.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/25/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterNavigationController.h"

@interface EnterNavigationController() <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation EnterNavigationController

#pragma mark - lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationBar.barTintColor = [UIColor blackColor];
  self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
  self.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:21]};
  
  self.interactivePopGestureRecognizer.enabled = YES;
  self.interactivePopGestureRecognizer.delegate = self;
  self.delegate = self;
  
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if (self.viewControllers.count == 1) {
    return;
  }
  
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
  [backButton setBackgroundImage:[UIImage imageNamed:@"icon_back_btn"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.topViewController.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  if (self.viewControllers.count == 1) {
    return NO;
  }
  return YES;
}

#pragma mark - action

- (void)backButtonClick:(UIButton *)sender
{
  [self popViewControllerAnimated:YES];
}


@end
