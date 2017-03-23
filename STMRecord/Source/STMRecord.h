//
//  STMRecord.h
//  STMPersistance
//
//  Created by iosci on 2017/3/21.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol STMRecord <NSObject>

@property (nonatomic, strong, readonly) NSDictionary *representationDictionary;
@property (nonatomic, strong, readonly) NSDictionary *jsonDictionary;

@end

extern id/**<STMRecord>*/ STMCreatRecordWithDictionary(NSDictionary *dic);
extern id/**<STMRecord>*/ STMCreatRecord();

NS_ASSUME_NONNULL_END
