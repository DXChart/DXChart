//
//  DXVolumeLayer.m
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXVolumeLayer.h"
#import "DXkLineModelConfig.h"

@implementation DXVolumeLayer

- (void)setLayerWithModel:(DXkLineModel *)model index:(NSInteger)i{
    
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    
    self.lineWidth = config.kLineWidth;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat x = i * (config.kLineWidth + config.layerToLayerGap)+ config.kLineWidth/2.;
    [path moveToPoint:CGPointMake(x, config.painterBottomToTop + model.height * config.painterBottomHeight)];
    [path addLineToPoint:CGPointMake(x , config.painterHeight )];
    self.strokeColor = self.fillColor = model.isPositive ? config.positiveColor.CGColor : config.negativeColor.CGColor;
    self.path = path.CGPath;
    
}

@end
