//
//  DXLineLayer.m
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXLineLayer.h"
#import "DXkLineModelConfig.h"

@interface DXLineLayer ()

@property (nonatomic, strong) UIBezierPath *strokePath;
@property (nonatomic, assign) DXLineType lineType;
@property (nonatomic, weak  ) DXkLineModelConfig *config;

@end


@implementation DXLineLayer

+ (instancetype)layerWithStartPoint:(CGPoint)point endPoint:(CGPoint)endPoint{
    DXLineLayer *layer = [DXLineLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addLineToPoint:endPoint];
    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    layer.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    layer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor;
    return layer;
}

+ (instancetype)layerWithType:(DXLineType)lineType{
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    DXLineLayer *layer = [DXLineLayer layer];
    layer.lineWidth = config.MALineWidth;
    UIColor *bgColor = [config getBgColorWithLineType:lineType];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = bgColor.CGColor;
    layer.strokePath = [UIBezierPath bezierPath];
    layer.config = config;
    layer.lineType = lineType;
    return layer;
}

- (void)setLayerWithModel:(DXkLineModel *)model index:(NSInteger)i{
    
    CGFloat x = i * (_config.kLineWidth + _config.layerToLayerGap)+ _config.MALineWidth/2. + _config.kLineWidth/2.;
    CGFloat totalHeight,total;
    switch (_lineType) {
            case DXLineTypeMA5:
            case DXLineTypeMA10:
            case DXLineTypeMA20:
            case DXLineTypeMA30:{
                total = (_config.highest - _config.lowest);
                totalHeight = _config.painterTopHeight * (_config.highest - [model getMADataWithType:_lineType])/total;
            }
            break;
            case DXLineTypeDIF:
            case DXLineTypeDEA:{
                total = (_config.macdHighest - _config.macdLowest);
                totalHeight =_config.painterHeight - _config.painterBottomHeight * (_config.macdHighest - [model getMADataWithType:_lineType])/total;
            }
            break;
    }
    
    if (!i) {
       [_strokePath moveToPoint:CGPointMake(x, totalHeight)]; 
    }
    else{
       [_strokePath addLineToPoint:CGPointMake(x, totalHeight)];
    }
}

- (void)finishDrawPath{
    self.path = _strokePath.CGPath;
}
- (void)clearPath{
    self.path = NULL;
    [self.strokePath removeAllPoints];
}

@end
