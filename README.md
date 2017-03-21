# STMRecord

鸭子模型，支持嵌套

## 使用

1. 定义一个协议并遵守 `STMRecord`

```objc
@protocol BookRecord, LanguageRecord;

@protocol UserRecord <STMRecord>

@property (nonatomic, strong) NSString *name;
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

```

2. 使用 `STMCreatRecordWithDictionary(NSDictionary *)` 创建模型

```objc
self.userInfo = @{
                    @"name" : @"张三",
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

id<UserRecord> user = STMCreatRecordWithDictionary(self.userInfo);
NSLog(@"\n\nuser:\n%@, %@\n\n", user.name, user.age);

  id<UserRecord> child = user.child;
  child.name = @"王五";
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

```
