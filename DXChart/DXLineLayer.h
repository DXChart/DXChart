//
//  DXLineLayer.h
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXBaseLayer.h"

@interface DXLineLayer : DXBaseLayer

@property (nonatomic, strong, readonly) UIBezierPath *strokePath;

// 直线
+ (instancetype)layerWithStartPoint:(CGPoint)point endPoint:(CGPoint)endPoint;

+ (instancetype)layerWithType:(DXLineType)lineType;


- (void)finishDrawPath;

@end
