//
//  DXkLineModel.h
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@import UIKit;
@class DXkLineModel;

typedef struct  {
    CGFloat maxHigh;
    CGFloat minLow;
    NSInteger maxHighIndex;
    NSInteger minLowIndex;
}maxAndHigh;


@interface DXkLineModelArray : NSObject<YYModel>

@property (nonatomic, strong) NSArray<DXkLineModel *> * chartlist;
@property (nonatomic, assign) BOOL success;
// caculator max volume
- (NSInteger)calculateMaxVolumeIndexWithRange:(NSRange)rang;
//
- (maxAndHigh)calculateMaxHightMinLowWithRange:(NSRange)rang;

@end

@interface DXkLineModel : NSObject

@property (nonatomic, assign) CGFloat chg;
@property (nonatomic, assign) CGFloat close;
@property (nonatomic, assign) CGFloat dea;
@property (nonatomic, assign) CGFloat dif;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat low;
@property (nonatomic, assign) CGFloat ma10;
@property (nonatomic, assign) CGFloat ma20;
@property (nonatomic, assign) CGFloat ma30;
@property (nonatomic, assign) CGFloat ma5;
@property (nonatomic, assign) CGFloat macd;
@property (nonatomic, assign) CGFloat open;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, assign) CGFloat turnrate;
@property (nonatomic, assign) NSInteger volume;
@property (nonatomic, assign) BOOL isPositive;


// view model
@property (nonatomic, assign) CGFloat height;

@end
