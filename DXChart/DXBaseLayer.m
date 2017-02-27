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


- (id<CAAction>)actionForKey:(NSString *)event{
    
    return [NSNull null];
}


- (BOOL)drawsAsynchronously{
    return YES;
}


@end
