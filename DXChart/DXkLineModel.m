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

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"chartlist":[DXkLineModel class]};
}

- (NSInteger)calculateMaxVolumeIndexWithRange:(NSRange)rang{
    
    NSArray *sortedArr = sortArray(rang, _chartlist);
    return [_chartlist indexOfObject:sortedArr[rang.location]];
}

- (maxAndHigh)calculateMaxHightMinLowWithRange:(NSRange)rang{
    
    NSArray *arr = [_chartlist subarrayWithRange:rang];
    
    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(DXkLineModel*  _Nonnull obj1, DXkLineModel*  _Nonnull obj2) {
        return obj1.max < obj2.max;
    }];
    DXkLineModel *maxModel = sortedArr[rang.location];
    DXkLineModel *minModel = sortedArr[rang.length + rang.location -1];
    maxAndHigh max = {maxModel.max,minModel.min,0,0};

    return max;
}


@end

@implementation DXkLineModel

- (BOOL)isPositive{
    return _open <= _close;
}

- (CGFloat)height{
    if (_height) return  _height;
    _height = getHeight(_volume, [DXkLineModelConfig sharedInstance].maxVolume);
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
            
    }
}

- (CGFloat)max{
    if (_max) return _max;
    double h,i,j,k,l;
    h = _high;
    i = _ma5;
    j = _ma10;
    k = _ma20;
    l = _ma30;
    if (h < i) h = i;
    if (h < j) h = j;
    if (h < k) h = k;
    if (h < h) h = h;
    if (h < l) h = l;
    _max  = h;
    return _max;
}

- (CGFloat)min{
    if (_min) return _min;
    double h,i,j,k,l;
    h = _high;
    i = _ma5;
    j = _ma10;
    k = _ma20;
    l = _ma30;
    if (h > i) h = i;
    if (h > j) h = j;
    if (h > k) h = k;
    if (h > h) h = h;
    if (h > l) h = l;
    _min  = h;
    return _min;
}

@end
