//
//  DXBasePainter.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXBasePainter.h"


@implementation DXBasePainter

- (void)clearContent{
    
}

- (void)reloadWithModels:(NSArray<DXkLineModel *> *)models{
    
    
    
}

- (void)addBorder{
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    // add dash
    DXDashLayer *dashLayer1 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4.)];
    DXBaseLayer *midLineLayer = [DXBaseLayer layer];
    midLineLayer.frame = CGRectMake(0, config.painterTopHeight / 2., config.painterWidth, 0.5);
    midLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    DXDashLayer *dashLayer2 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 3.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 3.)];
    DXDashLayer *dashLayer3 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 5. + config.painterMidGap) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 5. + config.painterMidGap)];
    // add border
    DXBorderLayer *topBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, 0, config.painterWidth, config.painterTopHeight)];
    DXBorderLayer *bottomBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, config.painterBottomToTop, config.painterWidth, config.painterBottomHeight)];
    // notice: 有顺序
    [self.layer addSublayer:topBorder];
    [self.layer addSublayer:bottomBorder];
    [self.layer addSublayer:dashLayer1];
    [self.layer addSublayer:dashLayer2];
    [self.layer addSublayer:midLineLayer];
    [self.layer addSublayer:dashLayer3];
}


@end
