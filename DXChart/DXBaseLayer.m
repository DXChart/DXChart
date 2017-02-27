//
//  DXBaseLayer.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXBaseLayer.h"

@implementation DXBaseLayer

- (void)setLayerWithModel:(DXkLineModel *)model index:(NSInteger)i{
    
}

- (void)clearPath{
    self.path = NULL;
}

- (void)setPath:(CGPathRef)path{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setPath:path];
    [CATransaction commit];
    
    
}

- (void)setStrokeColor:(CGColorRef)strokeColor{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setStrokeColor:strokeColor];
    [CATransaction commit];
}

- (void)setFillColor:(CGColorRef)fillColor{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setFillColor:fillColor];
    [CATransaction commit];
}
@end
