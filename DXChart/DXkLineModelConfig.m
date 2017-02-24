//
//  DXkLineModelConfig.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXkLineModelConfig.h"

@interface DXkLineModelConfig ()


@end

@implementation DXkLineModelConfig

+ (instancetype)sharedInstance{
    static DXkLineModelConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config  = [[DXkLineModelConfig alloc] init];
        config.positiveColor = [UIColor redColor];
        config.negativeColor = [UIColor greenColor];
        config.layerToLayerGap = 1;
        config.painterTopHeight = 180;
        config.painterBottomHeight = 60;
        config.topMargin = 2;
        config.kLineWidth = 5;
    });
    return config;
}

- (CGFloat)painterBottomToTop{
    return _painterMidGap + _painterTopHeight;
}

- (CGFloat)highest{
    return ( _maxHigh - _minLow) / 6 + _maxHigh;
}

- (CGFloat)lowest{
    return _minLow - ( _maxHigh - _minLow) / 6;
}

@end
