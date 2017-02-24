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
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    // add dash
    DXDashLayer *dashLayer1 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4.)];
    DXBaseLayer *midLineLayer = [DXBaseLayer layer];
    midLineLayer.frame = CGRectMake(0, config.painterTopHeight / 2., config.painterWidth, 0.5);
    midLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    DXDashLayer *dashLayer2 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 3.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 3.)];
    DXDashLayer *dashLayer3 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 5. + config.painterMidGap) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 5. + config.painterMidGap)];
    
    [self.layer addSublayer:dashLayer1];
    [self.layer addSublayer:dashLayer2];
    [self.layer addSublayer:midLineLayer];
    [self.layer addSublayer:dashLayer3];
}


@end
