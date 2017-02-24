//
//  DXLineLayer.h
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXBaseLayer.h"

@interface DXLineLayer : DXBaseLayer

+ (instancetype)layerWithStartPoint:(CGPoint)point endPoint:(CGPoint)endPoint;

@end
