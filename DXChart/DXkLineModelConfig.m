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
        config.topMargin = 2;
        config.kOriginLineWidth = 5;
        config.kLineWidth = config.kOriginLineWidth;
        config.scaleBound = 0.03;
        config.ScaleFactor = 0.03f;
        //一定在scale之前设置
        config.minScale = 0.5;
        config.maxScale = 2;
        config.scale = 1.0f;
        config.kLineWidth = 5;
        config.ma5Color = [UIColor orangeColor];
        config.ma10Color = [UIColor cyanColor];
        config.ma20Color = [UIColor blueColor];
        config.ma30Color = [UIColor purpleColor];
        config.difColor = [UIColor magentaColor];
        config.deaColor = [UIColor brownColor];
        config.MALineWidth = 0.5;
    });
    return config;
}


-(UIColor *)getBgColorWithLineType:(DXLineType)lineType{
    switch (lineType) {
            case DXLineTypeMA5:
                return _ma5Color;
            break;
            case DXLineTypeMA10:
                return _ma10Color;
            break;
            case DXLineTypeMA20:
                return _ma20Color;
            break;
            case DXLineTypeMA30:
                return _ma30Color;
            break;
            case DXLineTypeDIF:
                return _difColor;
            break;
            case DXLineTypeDEA:
                return _deaColor;
            break;
            
    }
}

#pragma mark - Getter & Setter

- (CGFloat)painterBottomToTop{
    return _painterMidGap + _painterTopHeight;
}

- (CGFloat)highest{
    return ( _maxHigh - _minLow) / 6 + _maxHigh;
}

- (CGFloat)lowest{
    return _minLow - ( _maxHigh - _minLow) / 6;
}
- (void)setScale:(CGFloat)scale{
    if (scale > _maxScale) {
        _scale = _maxScale;
    }else if(scale < _minScale){
        _scale = _minScale;
    }else{
        _scale = scale;
    }
}




@end
