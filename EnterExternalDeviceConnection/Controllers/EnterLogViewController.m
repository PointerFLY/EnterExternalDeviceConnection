//
//  EnterLogViewController.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/7/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterLogViewController.h"
#import "EnterLogManager.h"

@interface EnterLogViewController()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation EnterLogViewController

#pragma mark - lifecycle

- (void)loadView
{
  self.view = self.textView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.textView.text = [[EnterLogManager manager] readLog];
}

#pragma mark - accessor

- (UITextView *)textView
{
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.scrollEnabled = YES;
    _textView.scrollsToTop = YES;
    _textView.font = [UIFont systemFontOfSize:16];
  }

  return _textView;
}

@end
