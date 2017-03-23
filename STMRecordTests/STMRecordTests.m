//
//  STMRecordTests.m
//  STMRecordTests
//
//  Created by iosci on 2017/3/21.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STMRecord.h"

@protocol BookRecord, LanguageRecord;
@protocol UserRecord <STMRecord>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *familyName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) id<UserRecord> child;
@property (nonatomic, strong) NSArray<id<BookRecord>> *books;
@property (nonatomic, strong) NSArray<NSArray<id<LanguageRecord>> *> *lanuages;

@end

@protocol BookRecord <STMRecord>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *price;

@end

@protocol LanguageRecord <STMRecord>

@property (nonatomic, strong) NSString *name;

@end

@interface STMRecordTests : XCTestCase

@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation STMRecordTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  self.userInfo = @{
                    @"name" : @"三儿",
                    @"familyName" : @"张",
                    @"age" : @30,
                    @"child" : @{
                        @"name" : @"李四",
                        @"age" : @10
                        },
                    @"books" : @[//数组套字典
                        @{
                          @"name" : @"iOS",
                          @"price" : @(60.56)
                          },
                        @{
                          @"name" : @"JavaScript",
                          @"price" : @(30.15)
                          }
                        ],
                    @"lanuages" : @[//数组套数组
                        @[@{
                            @"name" : @"Chinese"
                            }],
                        @[@{
                            @"name" : @"English"
                            }]
                        ]
                    };
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testExample {
  id<UserRecord> user = STMCreatRecordWithDictionary(self.userInfo);
  NSLog(@"\n\nuser:\n%@, %@\n\n", user.name, user.age);
  
  id<UserRecord> child = user.child;
  NSLog(@"\n\nchild:\n%@, %@\n\n", child.name, child.age);
  
  NSArray<id<BookRecord>> *books = user.books;
  [books enumerateObjectsUsingBlock:^(id<BookRecord>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSLog(@"\n\nbook %lu: %@, %@\n\n", (unsigned long)idx, obj.name, obj.price);
  }];
  
  NSArray<NSArray<id<LanguageRecord>> *> *lanuages = user.lanuages;
  [lanuages enumerateObjectsUsingBlock:^(NSArray<id<LanguageRecord>> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj enumerateObjectsUsingBlock:^(id<LanguageRecord>  _Nonnull lanuage, NSUInteger idx, BOOL * _Nonnull stop) {
      NSLog(@"\n\nlanuage: %@\n\n", lanuage.name);
    }];
  }];
  
  NSLog(@"\n\ntest read\n%@\n\n%@\n\n", [user representationDictionary], [user jsonDictionary]);
}

- (void)testSave {
  id<UserRecord> user = STMCreatRecord();
  user.familyName = @"王";
  user.name = @"小明";
  user.age = @38;
  
  id<UserRecord> child = STMCreatRecord();
  child.name = @"小强";
  child.age = @12;
  
  id<BookRecord> book1 = STMCreatRecord();
  book1.name = @"iOS 开发进阶";
  book1.price = @60;
  book1.name = nil;
  
  id<BookRecord> book2 = STMCreatRecord();
  book2.name = @"iOS 开发进阶（第二版）";
  book2.price = @60;
  [book2 setPrice:nil];//设为nil表示移除
  
  id<LanguageRecord> lanuage1 = STMCreatRecord();
  lanuage1.name = @"English";
  
  user.child = child;
  user.books = @[book1, book2];
  user.lanuages = @[
                    @[lanuage1]
                    ];
  
  NSLog(@"\n\ntest save\n%@\n%@\n\n%@\n\n", user.familyName, [user representationDictionary], [user jsonDictionary]);
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
    // Put the code you want to measure the time of here.
  }];
}

@end
