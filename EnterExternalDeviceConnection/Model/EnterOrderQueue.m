//
//  EnterOrderQueue.m
//  EnterExternalDeviceConnection
//
//  Created by PointerFLY on 10/8/15.
//  Copyright © 2015 PointerFLY. All rights reserved.
//

#import "EnterOrderQueue.h"

#define ENTER_SAFE_ORDER_NODE_FREE(v) \
do { \
  free(v->ptrData); \
  free(v); \
  v = nil; \
} while(0)

typedef struct EnterOrderNode EnterOrderNode;
struct EnterOrderNode {
  Byte *ptrData;
  EnterOrderNode *ptrNext;
};

@interface EnterOrderQueue()
@property (nonatomic, assign) EnterOrderNode *head;
@property (nonatomic, assign) EnterOrderNode *tail;
@end

@implementation EnterOrderQueue

#pragma mark - init & dealloc

- (instancetype)init
{
  if (self = [super init]) {
  }
  
  return self;
}

- (void)dealloc
{
  EnterOrderNode *node = self.head;
  
  while (node) {
    self.head = node->ptrNext;
    ENTER_SAFE_ORDER_NODE_FREE(node);
  }
  ENTER_SAFE_ORDER_NODE_FREE(self.head);
}

#pragma mark - public

- (Byte *)deque
{
  if (self.head) {
    EnterOrderNode *node = self.head;
    self.head = node->ptrNext;
    if (!self.head->ptrNext) {
      self.tail = self.head;
    }
    
    Byte *ptrByte = node->ptrData;
    free(node);
    
    return ptrByte;
  }
  
  return nil;
}

- (void)enque:(Byte *)order
{
  EnterOrderNode *node = malloc(sizeof(EnterOrderNode));
  node->ptrData = order;
  node->ptrNext = nil;
  
  if (!self.head->ptrNext) {
    self.head->ptrNext = node;
  }
  self.tail = node;
}

#pragma mark - accessor

- (BOOL)isEmpty
{
  return (self.head->ptrNext == nil);
}

- (EnterOrderNode *)head
{
  if (!_head) {
    _head = malloc(sizeof(EnterOrderNode));
    _head->ptrData = nil;
    _head->ptrNext = nil;
  }
  
  return _head;
}

- (EnterOrderNode *)tail
{
  if (!_tail) {
    EnterOrderNode *node = self.head;
    
    while (node->ptrNext) {
      node = node->ptrNext;
    }
    
    _tail = node;
  }
  
  return _tail;
}

@end
