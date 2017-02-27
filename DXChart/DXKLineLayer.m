//
//  DXKLineLayer.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXKLineLayer.h"
#import "DXkLineModelConfig.h"

@implementation DXKLineLayer
- (void)setLayerWithModel:(DXkLineModel *)model index:(NSInteger)i{

    CGFloat lineWidth = 1;
    self.lineWidth = lineWidth;
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    CGFloat X,Y,totalHeight;
    CGFloat total = (config.highest - config.lowest);
    if (!model.isPositive){
        Y = (config.highest - model.open ) / total;
    }
    else{
        Y = (config.highest - model.close) / total;
    }
    
    totalHeight = fabs((double)(model.open - model.close)) / (config.highest - config.lowest);
    X  = i * (config.kLineWidth  + config.layerToLayerGap) + lineWidth / 2.;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(X, Y * config.painterTopHeight + lineWidth / 2. , config.kLineWidth - lineWidth,totalHeight * config.painterTopHeight - lineWidth)];
    
    [path moveToPoint:CGPointMake(X + config.kLineWidth /2. - lineWidth / 2.,  (config.highest - model.high)/ total * config.painterTopHeight)];
    [path addLineToPoint:CGPointMake(X + config.kLineWidth / 2. - lineWidth / 2., (config.highest - model.low)/ total * config.painterTopHeight)];
//    NSLog(@"%lf,%lf,%lf",config.maxHigh - model.high,config.minLow,model.low - config.minLow);
    self.path = path.CGPath;
    self.strokeColor = self.fillColor = model.isPositive ? config.positiveColor.CGColor : config.negativeColor.CGColor;
}

@end
