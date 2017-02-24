//
//  DXDashLayer.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXDashLayer.h"
#import <UIKit/UIKit.h>

@implementation DXDashLayer

+ (instancetype)layerWithStartPoint:(CGPoint)point endPoint:(CGPoint)endPoint{
    DXDashLayer *layer = [super layerWithStartPoint:point endPoint:endPoint];
    layer.lineDashPhase = 0;
    layer.lineDashPattern = @[@1,@1];
    return layer;
}

@end
