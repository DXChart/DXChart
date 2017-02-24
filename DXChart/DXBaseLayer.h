//
//  DXBaseLayer.h
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DXkLineModel.h"

@interface DXBaseLayer : CAShapeLayer

- (void)setLayerWithModel:(DXkLineModel *)model index:(NSInteger)i;

@end
