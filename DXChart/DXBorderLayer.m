//
//  DXBorderLayer.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXBorderLayer.h"
#import <UIKit/UIKit.h>

@implementation DXBorderLayer

+ (instancetype)layerWithFrame:(CGRect)frame{
    DXBorderLayer *layer = [DXBorderLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    layer.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    layer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
    
    return  layer;
}

@end
