//
//  ViewController.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 9/21/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterInfoViewController.h"

@interface EnterInfoViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RETableViewSection *section;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) RETableViewManager *manager;
@end

@implementation EnterInfoViewController

#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAccessoryDidConnect:) name:kEnterAccessoryDidConnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAccessoryDidDisconnect:) name:kEnterAccessoryDidDisconnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStreamDidOpen:) name:kEnterStreamDidOpenNotification object:nil];
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
  self.title = @"Lightning Info";
  
  [self manager];
}

#pragma mark - action

- (void)handleAccessoryDidConnect:(NSNotification *)notification
{
  [SVProgressHUD showSuccessWithStatus:@"Connected"];
  [self reloadTableView];
}

- (void)handleAccessoryDidDisconnect:(NSNotification *)notification
{
  [SVProgressHUD showInfoWithStatus:@"Disconnected"];
  [self reloadTableView];
}

- (void)handleStreamDidOpen:(NSNotification *)notification
{

}

#pragma mark - private 

- (void)reloadTableView
{
  self.items = nil;
  self.section = nil;
  self.manager = nil;
  
  [self manager];
  [self.tableView reloadData];
}

#pragma mark - accessor

- (RETableViewManager *)manager
{
  if (!_manager) {
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    [_manager addSection:self.section];
  }
  
  return _manager;
}

- (RETableViewSection *)section
{
  if (!_section) {
    _section = [[RETableViewSection alloc] initWithHeaderTitle:[EnterLightningConnectionManager manager].connected ? @"connected" : @"unconnected"];
    _section.headerHeight = 36;
    
    for (RETableViewItem *item in self.items) {
      [_section addItem:item];
    }
  }
  
  return _section;
}

- (NSArray *)items
{
  if (!_items) {
    NSArray *titles = @[@"Name", @"Manufacturer", @"ModelNumber", @"SerialNumber", @"ProtocolString", @"FirmwareVersion", @"HardwareVersion"];
    EAAccessory *accessory = [EnterLightningConnectionManager manager].accessory;
    NSArray *details;
    
    if ([EnterLightningConnectionManager manager].connected) {
      details = @[accessory.name, accessory.manufacturer, accessory.modelNumber, accessory.serialNumber, accessory.protocolStrings[1], accessory.firmwareRevision, accessory.hardwareRevision];
    } else {
      details = @[@"NULL", @"NULL", @"NULL", @"NULL", @"NULL", @"NULL", @"NULL"];
    }
    
    NSMutableArray *mutableItems = [[NSMutableArray alloc] init];
    
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      RETableViewItem *item = [[RETableViewItem alloc] initWithTitle:(NSString *)obj];
      item.style = UITableViewCellStyleValue1;
      item.selectionStyle = UITableViewCellSelectionStyleNone;
      item.detailLabelText = details[idx];
      
      [mutableItems addObject:item];
    }];
    
    _items = [mutableItems copy];
  }
  
  return _items;
}

- (UITableView *)tableView
{
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
  }
  
  return _tableView;
}

@end
