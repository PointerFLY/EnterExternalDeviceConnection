//
//  EnterMonitorViewController.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/29/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterMonitorViewController.h"
#import "EnterMessageViewController.h"
#import "EnterLogViewController.h"

@interface EnterMonitorViewController()
@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *items;
@end

@implementation EnterMonitorViewController

#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleManagerDidUpdateStatistics:) name:kEnterDidUpdateStatisticsNotification object:nil];
  }
  
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - lifecycle

- (void)loadView
{
  self.view = self.tableView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Monitor";
  
  [self setNavigation];
  [self manager];
}

- (void)setNavigation
{
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonClicked:)];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(messageButtonClicked:)];
}

#pragma mark - action

- (void)messageButtonClicked:(UIBarButtonItem *)sender
{
  EnterMessageViewController *messageViewController = [[EnterMessageViewController alloc] init];
  [self.navigationController pushViewController:messageViewController animated:YES];
}

- (void)resetButtonClicked:(UIBarButtonItem *)sender
{
  UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"Are you sure to reset statistics?"];
  
  [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
  [actionSheet bk_setDestructiveButtonWithTitle:@"Confirm Reseting" handler:^() {
    [[EnterLightningConnectionManager manager] resetStatistics];
  }];
  
  [actionSheet showInView:self.view];
}

- (void)handleManagerDidUpdateStatistics:(NSNotification *)notification
{
  [self reloadTableView];
}

#pragma mark - private

- (void)reloadTableView
{
  self.manager = nil;
  self.sections = nil;
  self.items = nil;
  
  [self manager];
  [self.tableView reloadData];
}

#pragma mark - accessor

- (UITableView *)tableView
{
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
  }
  
  return _tableView;
}

- (RETableViewManager *)manager
{
  if (!_manager) {
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [_manager addSectionsFromArray:self.sections];
  }
  
  return _manager;
}

- (NSArray *)sections
{
  if (!_sections) {
    RETableViewSection *sectionA = [[RETableViewSection alloc] initWithHeaderTitle:@"Live Statistics"];
    sectionA.headerHeight = 36;
    
    for (NSUInteger i = 0; i < 3; i++) {
      [sectionA addItem:self.items[i]];
    }
    
    
    RETableViewSection *sectionB = [[RETableViewSection alloc] initWithHeaderTitle:@"Logs"];
    
    for (NSUInteger i = 3; i < 5; i++) {
      [sectionB addItem:self.items[i]];
    }
    
    _sections = @[sectionA, sectionB];
  }
  
  return _sections;
}

- (NSArray *)items
{
  if (!_items) {
    NSArray *titles = @[@"Receiving Speed", @"Pakage Count", @"Received Size", @"Recent Logs", @"Clear Logs"];
    NSArray *details;
    
    EnterLightningConnectionManager *manager = [EnterLightningConnectionManager manager];
    
    if (manager.connected) {
      
      details = @[[NSString stringWithFormat:@"%lu", (unsigned long)manager.receivingSpeed],
                  [NSString stringWithFormat:@"%lu", (unsigned long)manager.packageCount],
                  [NSString stringWithFormat:@"%lu", (unsigned long)manager.receivedSize],
                  @"", @""];
    } else {
      details = @[@"NULL", @"NULL", @"NULL", @"", @""];
    }
    
    NSMutableArray *mutableItems = [[NSMutableArray alloc] init];
    
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      RETableViewItem *item = [[RETableViewItem alloc] initWithTitle:(NSString *)obj];
      
      if (idx < 3) {
        item.style = UITableViewCellStyleValue1;
        item.selectionStyle = UITableViewCellSelectionStyleNone;
        item.detailLabelText = details[idx];
      } else if (idx == 3) {
        item.style = UITableViewCellStyleValue1;
        item.selectionStyle = UITableViewCellSelectionStyleDefault;
        item.detailLabelText = details[idx];
        item.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        __weak __typeof(self)weakSelf = self;
        item.selectionHandler = ^(id item) {
          __strong __typeof(weakSelf)strongSelf = weakSelf;
          EnterLogViewController *logViewController = [[EnterLogViewController alloc] init];
          [strongSelf.navigationController pushViewController:logViewController animated:YES];
          [item deselectRowAnimated:YES];
        };
      } else {
        item.style = UITableViewCellStyleValue1;
        item.selectionHandler = ^(id item) {
          [item deselectRowAnimated:YES];
          
          UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"Cleared logs can not be restored, are you sure to clear?"];
          [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
          [actionSheet bk_setDestructiveButtonWithTitle:@"Confirm Clearing" handler:^() {
            [[EnterLogManager manager] clearLog];
          }];
          [actionSheet showInView:self.view];
        };
      }
      
      [mutableItems addObject:item];
    }];
    
    _items = [mutableItems copy];
  }
  
  return _items;
}

@end
