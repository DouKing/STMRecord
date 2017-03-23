//
//  STMRecord.m
//  STMPersistance
//
//  Created by iosci on 2017/3/21.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "STMRecord.h"

@interface STMRecord : NSObject<STMRecord>

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property (nonatomic, strong, readonly) NSMutableDictionary *innerDic;

@end

@implementation STMRecord

- (instancetype)init {
  return [self initWithDictionary:@{}];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
  NSAssert([NSJSONSerialization isValidJSONObject:dic], @"JSON格式不正确！");
  self = [super init];
  if (self) {
    _innerDic = [self _recordDic:dic ?: @{}];
  }
  return self;
}

#pragma mark - Private Methods

- (NSMutableDictionary *)_recordDic:(NSDictionary *)dic {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  __weak typeof(self) weakSelf = self;
  [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:[NSDictionary class]]) {
      STMRecord *record = [[STMRecord alloc] initWithDictionary:obj];
      [result setObject:record forKey:key];
    } else if ([obj isKindOfClass:[NSArray class]]) {
      NSArray *arr = (NSArray *)obj;
      [result setObject:[weakSelf _recordArray:arr] forKey:key];
    } else {
      [result setObject:obj forKey:key];
    }
  }];
  return result;
}

- (NSArray *)_recordArray:(NSArray *)arr {
  NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:arr.count];
  __weak typeof(self) weakSelf = self;
  [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:[NSDictionary class]]) {
      STMRecord *record = [[STMRecord alloc] initWithDictionary:obj];
      [tempArray addObject:record];
    } else if ([obj isKindOfClass:[NSArray class]]) {
      [tempArray addObject:[weakSelf _recordArray:obj]];
    } else {
      [tempArray addObject:obj];
    }
  }];
  return [tempArray copy];
}

- (NSDictionary *)_originalDic:(NSDictionary *)dic {
  NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:dic.count];
  __weak typeof(self) weakSelf = self;
  [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:[NSArray class]]) {
      [result setObject:[weakSelf _originalArray:obj] forKey:key];
    } else if ([obj conformsToProtocol:@protocol(STMRecord)]) {
      NSDictionary *d = [(id<STMRecord>)obj representationDictionary];
      [result setObject:d forKey:key];
    } else {
      [result setObject:obj forKey:key];
    }
  }];
  return result;
}

- (NSArray *)_originalArray:(NSArray *)arr {
  NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:arr.count];
  __weak typeof(self) weakSelf = self;
  [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj conformsToProtocol:@protocol(STMRecord)]) {
      NSDictionary *d = [(id<STMRecord>)obj representationDictionary];
      [tempArray addObject:d];
    } else if ([obj isKindOfClass:[NSArray class]]) {
      [tempArray addObject:[weakSelf _originalArray:obj]];
    } else {
      [tempArray addObject:obj];
    }
  }];
  return tempArray;
}

#pragma mark - Helpers

- (NSString *)_propertyNameScanFromGetterSelector:(SEL)selector {
  NSString *selectorName = NSStringFromSelector(selector);
  NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
  if (parameterCount == 0) {
    return selectorName;
  }
  return nil;
}

- (NSString *)_propertyNameScanFromSetterSelector:(SEL)selector {
  NSString *selectorName = NSStringFromSelector(selector);
  NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
  if ([selectorName hasPrefix:@"set"] && parameterCount == 1) {
    NSUInteger firstColonLocation = [selectorName rangeOfString:@":"].location;
    return [selectorName substringWithRange:NSMakeRange(3, firstColonLocation - 3)].lowercaseString;
  }
  return nil;
}

#pragma mark - forwad

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  SEL changedSelector = aSelector;
  if ([self _propertyNameScanFromGetterSelector:aSelector]) {
    changedSelector = @selector(objectForKey:);
  } else if ([self _propertyNameScanFromSetterSelector:aSelector]) {
    changedSelector = @selector(setObject:forKey:);
  }
  NSMethodSignature *sign = [[self.innerDic class] instanceMethodSignatureForSelector:changedSelector];
  return sign;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
  NSString *propertyName = nil;
  
  propertyName = [self _propertyNameScanFromGetterSelector:anInvocation.selector];
  if (propertyName) {
    anInvocation.selector = @selector(objectForKey:);
    [anInvocation setArgument:&propertyName atIndex:2]; // self, _cmd, key
    [anInvocation invokeWithTarget:self.innerDic];
    return;
  }
  
  propertyName = [self _propertyNameScanFromSetterSelector:anInvocation.selector];
  if (propertyName) {
    anInvocation.selector = @selector(setObject:forKey:);
    [anInvocation setArgument:&propertyName atIndex:3]; // self, _cmd, obj, key
    [anInvocation invokeWithTarget:self.innerDic];
    return;
  }
  
  [super forwardInvocation:anInvocation];
}

#pragma mark - setter & getter

- (NSDictionary *)representationDictionary {
  return self.innerDic;
}

- (NSDictionary *)jsonDictionary {
  return [self _originalDic:self.innerDic];
}

@end

id/**<STMRecord>*/ STMCreatRecord() {
  return [[STMRecord alloc] init];
}

id/**<STMRecord>*/ STMCreatRecordWithDictionary(NSDictionary *dic) {
  return [[STMRecord alloc] initWithDictionary:dic];
}
