//
//  EnterMessageViewController.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/25/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterMessageViewController.h"

@interface EnterMessageViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation EnterMessageViewController

#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  }
  
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setNavigation];
  
  [self.view addSubview:self.textView];
  self.view.userInteractionEnabled = YES;
  self.textView.userInteractionEnabled = YES;
  [self.textView becomeFirstResponder];
}

- (void)setNavigation
{
  self.title = @"Message";
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClicked:)];
}
#pragma mark - action

- (void)sendButtonClicked:(UIBarButtonItem *)sender
{
  //filter
  if (![EnterLightningConnectionManager manager].writable) {
    [SVProgressHUD showErrorWithStatus:@"Lightning not writable!"];
    return;
  }
  NSString *text = self.textView.text;
  if (text.length == 0) {
    [SVProgressHUD showErrorWithStatus:@"Empty content"];
    return;
  }
  
  Byte bytes[kEnterStreamMaxLength];
  
  for (NSUInteger i = 0; i < text.length; i++) {
    char c = [text characterAtIndex:i];
    bytes[i] = c;
  }
  for (NSUInteger i = text.length; i < kEnterStreamMaxLength; i++) {
    bytes[i] = '\0';
  }
  
  [[EnterLightningConnectionManager manager] send:bytes];
  [SVProgressHUD showSuccessWithStatus:@"Send bytes succeeded"];
}

- (void)handleKeyboardWillShow:(NSNotification *)notification
{
  NSDictionary *info = notification.userInfo;
  
  NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardEndFrame = [value CGRectValue];
  CGFloat height = keyboardEndFrame.size.height;
  
  self.textView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - height);
}

#pragma mark - accessor

- (UITextView *)textView
{
  if (!_textView) {
    _textView = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _textView.font = [UIFont systemFontOfSize:30];
    _textView.textColor = [UIColor blueColor];
    _textView.keyboardType = UIKeyboardTypeAlphabet;
    _textView.keyboardAppearance = UIKeyboardAppearanceDark;
    _textView.scrollEnabled = YES;
  }
  
  return _textView;
}

@end
