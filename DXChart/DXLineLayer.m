//
//  DXLineLayer.m
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXLineLayer.h"

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

@end
