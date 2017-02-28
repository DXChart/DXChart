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

typedef NS_ENUM(NSUInteger, DXLineType) {
    DXLineTypeMA5 = 1,
    DXLineTypeMA10,
    DXLineTypeMA20,
    DXLineTypeMA30,
    DXLineTypeDIF,
    DXLineTypeDEA
};
typedef NS_OPTIONS(NSUInteger, DXChartType) {
    DXChartTypeVolume = 1 << 0,
    DXChartTypeMACD = 1 << 1,
    DXChartTypeMA = 1 << 2,
    DXChartTypeKline = 1 << 3
};

@interface DXkLineModelArray : NSObject<YYModel>
+ (instancetype)sharedInstance;
@property (nonatomic,assign) NSInteger arrayCount;
@property (nonatomic, strong) NSArray<DXkLineModel *> * chartlist;
@property (nonatomic, assign) BOOL success;
// caculator max volume
- (CGFloat)calculateMaxVolumeIndexWithRange:(NSRange)rang;
// kLine(MA) max and min
- (maxAndHigh)calculateMaxHightMinLowWithRange:(NSRange)rang;
// MACD DIF DEA (DIF - DEA)
- (maxAndHigh)calculateMaxAndMinMACDWithRange:(NSRange)rang;

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
// max high (has high and ma series..)
@property (nonatomic, assign) CGFloat max;
// min
@property (nonatomic, assign) CGFloat min;

// MACD min max
@property (nonatomic, assign) CGFloat minMACD;
@property (nonatomic, assign) CGFloat maxMACD;
@property (nonatomic, assign) BOOL calculatedMaxMACD;
@property (nonatomic, assign) BOOL calculatedMinMACD;
@property (nonatomic, assign) BOOL isPositiveMACD;


- (CGFloat)getMADataWithType:(DXLineType)type;

@end
