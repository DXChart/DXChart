//
//  DXBasePainter.h
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXLayers.h"
#import "DXkLineModelConfig.h"
#import "DXkLineModel.h"

@interface DXBasePainter : UIView


- (void)clearContent;

- (void)reloadWithModels:(NSArray<DXkLineModel *> *)models;

@end
