//
//  DXkLineModel.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXkLineModel.h"
#import "DXkLineModelConfig.h"

#define force_inline __inline__ __attribute__((always_inline))
static force_inline CGFloat getHeight(CGFloat volume, CGFloat maxVolume) {
    return (CGFloat)volume / maxVolume;
}

static force_inline NSArray * sortArray(NSRange rang,NSArray *chartList) {
    NSArray *arr = [chartList subarrayWithRange:rang];
    
    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(DXkLineModel*  _Nonnull obj1, DXkLineModel*  _Nonnull obj2) {
        return obj1.volume < obj2.volume;
    }];
    return sortedArr;
}

@implementation DXkLineModelArray

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //加载本地数据,创建单列对象
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"kLineForDay" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        instance = [DXkLineModelArray yy_modelWithDictionary:json];
    });
    return instance;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"chartlist":[DXkLineModel class]};
}

- (void)setChartlist:(NSArray<DXkLineModel *> *)chartlist{
    _chartlist = chartlist;
    _arrayCount = chartlist.count;
}

- (NSInteger)calculateMaxVolumeIndexWithRange:(NSRange)rang{
    
    NSArray *sortedArr = sortArray(rang, _chartlist);
    return [_chartlist indexOfObject:sortedArr[rang.location]];
}

- (maxAndHigh)calculateMaxHightMinLowWithRange:(NSRange)rang{
    
    NSArray *arr = [_chartlist subarrayWithRange:rang];
    
    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(DXkLineModel*  _Nonnull obj1, DXkLineModel*  _Nonnull obj2) {
        return obj1.high < obj2.high;
    }];
    DXkLineModel *maxModel = sortedArr[rang.location];
    DXkLineModel *minModel = sortedArr[rang.length + rang.location -1];
    maxAndHigh max = {maxModel.high,minModel.low,0,0};

    return max;
}


@end

@implementation DXkLineModel

- (BOOL)isPositive{
    return _open < _close;
}

- (CGFloat)height{
    return getHeight(_volume, [DXkLineModelConfig sharedInstance].maxVolume);
}

@end
