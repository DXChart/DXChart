//
//  DXMACDLayer.m
//  DXChart
//
//  Created by caijing on 17/2/27.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXMACDLayer.h"
#import "DXkLineModelConfig.h"

@implementation DXMACDLayer

- (void)setLayerWithModel:(DXkLineModel *)model index:(NSInteger)i{
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    self.lineWidth = config.kLineWidth;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat x = i * (config.kLineWidth + config.layerToLayerGap)+ config.kLineWidth/2.;
    CGFloat difdea = model.dif - model.dea;
    CGFloat zeroLevelY = config.painterBottomToTop + (config.macdHighest / (config.macdHighest - config.macdLowest)) * config.painterBottomHeight;
    if (model.isPositiveMACD){
        [path moveToPoint:CGPointMake(x,config.painterBottomToTop + ((config.macdHighest - difdea) / (config.macdHighest - config.macdLowest)) * config.painterBottomHeight )];
        [path addLineToPoint:CGPointMake(x , zeroLevelY)];
    }else{
        
        [path moveToPoint:CGPointMake(x , zeroLevelY)];
        [path addLineToPoint:CGPointMake(x,zeroLevelY + ( - difdea / (config.macdHighest - config.macdLowest)) * config.painterBottomHeight )];
    }
//    NSLog(@"%lf,%lf,%lf,%lf,%lf",config.macdHighest ,config.macdLowest,model.dif,model.dea,difdea);
    self.strokeColor = self.fillColor = model.isPositiveMACD > 0 ? config.positiveColor.CGColor : config.negativeColor.CGColor;
    self.path = path.CGPath;
}


@end
