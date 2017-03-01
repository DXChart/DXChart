//
//  DXCrossLinePainter.h
//  DXChart
//
//  Created by caijing on 17/3/1.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXBasePainter.h"

@interface DXCrossLinePainter : DXBasePainter

- (void)moveToIndex:(NSInteger)index y:(CGFloat)y;
- (void)hiddenCrossLine;

@end
