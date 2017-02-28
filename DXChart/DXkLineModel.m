//
//  DXkLineModel.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXkLineModel.h"
#import "DXkLineModelConfig.h"
#import <mach/mach_time.h>

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
    return [_chartlist indexOfObject:sortedArr[0]];
}

- (maxAndHigh)calculateMaxHightMinLowWithRange:(NSRange)rang{
    
    NSArray *arr = [_chartlist subarrayWithRange:rang];
    
    CGFloat max = 0.0,min = 0.0;
    for (DXkLineModel *model in arr) {
        if (max < model.max) max = model.max;
        if (min > model.min) min = model.min;
    }
    maxAndHigh max1 = {max,min,0,0};
    return max1;
}

- (maxAndHigh)calculateMaxAndMinMACDWithRange:(NSRange)rang{
    
    NSArray *arr = [_chartlist subarrayWithRange:rang];
    
    NSArray *sortedArr1 = [arr sortedArrayUsingComparator:^NSComparisonResult(DXkLineModel*  _Nonnull obj1, DXkLineModel*  _Nonnull obj2) {
        return obj1.maxMACD < obj2.maxMACD;
    }];
    NSArray *sortedArr2 = [arr sortedArrayUsingComparator:^NSComparisonResult(DXkLineModel*  _Nonnull obj1, DXkLineModel*  _Nonnull obj2) {
        return obj1.minMACD > obj2.minMACD;
    }];
    DXkLineModel *maxModel = sortedArr1[0];
    DXkLineModel *minModel = sortedArr2[0];
    
    maxAndHigh max = {maxModel.maxMACD,minModel.minMACD,0,0};
    
    return max;
}


@end

@implementation DXkLineModel

- (BOOL)isPositive{
    return _open <= _close;
}

- (CGFloat)height{
    _height = getHeight(_volume, [DXkLineModelConfig sharedInstance].maxVolume) * [DXkLineModelConfig sharedInstance].painterBottomHeight;
    return _height;
}

- (CGFloat)getMADataWithType:(DXLineType)type{
    switch (type) {
            case DXLineTypeMA5:
                return _ma5;
            break;
            case DXLineTypeMA10:
                return _ma10;
            break;
            case DXLineTypeMA20:
                return _ma20;
            break;
            case DXLineTypeMA30:
                return _ma30;
            break;
            case DXLineTypeDIF:
                return _dif;
            break;
            case DXLineTypeDEA:
                return _dea;
            break;
            
    }
}

- (CGFloat)max{
    if (_max) return _max;
    float h,i,j,k,l;
    h = _high;
    i = _ma5;
    j = _ma10;
    k = _ma20;
    l = _ma30;
    if (h < i) h = i;
    if (h < j) h = j;
    if (h < k) h = k;
    if (h < l) h = l;
    _max  = h;
    return _max;
}

- (CGFloat)min{
    if (_min) return _min;
    float h,i,j,k,l;
    h = _low;
    i = _ma5;
    j = _ma10;
    k = _ma20;
    l = _ma30;
    if (h > i) h = i;
    if (h > j) h = j;
    if (h > k) h = k;
    if (h > l) h = l;
    _min  = h;
    return _min;
}

- (CGFloat)maxMACD{
    if (_calculatedMaxMACD) return _maxMACD;
    _calculatedMaxMACD = YES;
    float h,i,j;
    h = _dif;
    i = _dea;
    j = _dif - _dea;
    if (h < i) h = i;
    if (h < j) h = j;
    _maxMACD  = h;
    return _maxMACD;
}

- (CGFloat)minMACD{
    if (_calculatedMinMACD) return _minMACD;
    _calculatedMinMACD = YES;
    float h,i,j;
    h = _dif;
    i = _dea;
    j = _dif - _dea;
    if (h > i) h = i;
    if (h > j) h = j;
    _minMACD  = h;
    return _minMACD;
}

- (BOOL)isPositiveMACD{
    
    return (_dif - _dea) > 0;
}

@end
