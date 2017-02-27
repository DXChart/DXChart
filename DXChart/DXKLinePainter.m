//
//  DXKLinePainter.m
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXKLinePainter.h"

@interface DXKLinePainter ()

@property (nonatomic, strong) NSMutableArray *kLineLayers;
@property (nonatomic, strong) NSMutableArray *volumeLineLayers;

@end

@implementation DXKLinePainter

- (void)clearContent{
    
    
}

- (void)reloadWithModels:(NSArray<DXkLineModel *> *)models{
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    // add dash
    DXDashLayer *dashLayer1 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4.)];
    DXBaseLayer *midLineLayer = [DXBaseLayer layer];
    midLineLayer.frame = CGRectMake(0, config.painterTopHeight / 2., config.painterWidth, 0.5);
    midLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    DXDashLayer *dashLayer2 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 3.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 3.)];
    DXDashLayer *dashLayer3 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 5. + config.painterMidGap) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 5. + config.painterMidGap)];
    
    
    DXLineLayer *ma5Line = [DXLineLayer layerWithType:DXLineTypeMA5];
    DXLineLayer *ma10Line = [DXLineLayer layerWithType:DXLineTypeMA10];
    DXLineLayer *ma20Line = [DXLineLayer layerWithType:DXLineTypeMA20];
    DXLineLayer *ma30Line = [DXLineLayer layerWithType:DXLineTypeMA30];
    
    // add kline ,volume
    for (int i = 0 ; i < models.count; i ++) {
        
        if (!self.volumeLineLayers.count) {
            DXVolumeLayer *volumeLayershapeLayer = [DXVolumeLayer layer]; // 需要抽离
            [volumeLayershapeLayer setLayerWithModel:models[i] index:i];
            [self.layer addSublayer:volumeLayershapeLayer];
        }
        if (!self.kLineLayers.count) {
            DXKLineLayer *kLineshapeLayer = [DXKLineLayer layer]; // 需要抽离
            [self.kLineLayers addObject:kLineshapeLayer];
            [kLineshapeLayer setLayerWithModel:models[i] index:i];
            [self.layer addSublayer:kLineshapeLayer];
        }
        
        [ma5Line setLayerWithModel:models[i] index:i];
        [ma10Line setLayerWithModel:models[i] index:i];
        [ma20Line setLayerWithModel:models[i] index:i];
        [ma30Line setLayerWithModel:models[i] index:i];
        
        if (i == (models.count - 1)){
            [ma5Line finishDrawPath];
            [ma30Line finishDrawPath];
            [ma20Line finishDrawPath];
            [ma10Line finishDrawPath];
        }
        
    }
    
    // add border
    DXBorderLayer *topBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, 0, config.painterWidth, config.painterTopHeight)];
    DXBorderLayer *bottomBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, config.painterBottomToTop, config.painterWidth, config.painterBottomHeight)];
    // notice: 有顺序
    [self.layer addSublayer:dashLayer1];
    [self.layer addSublayer:dashLayer2];
    [self.layer addSublayer:midLineLayer];
    [self.layer addSublayer:dashLayer3];
    [self.layer addSublayer:topBorder];
    [self.layer addSublayer:bottomBorder];
    [self.layer addSublayer:ma5Line];
    [self.layer addSublayer:ma10Line];
    [self.layer addSublayer:ma20Line];
    [self.layer addSublayer:ma30Line];
}

#pragma mark - Getter & Setter

- (NSMutableArray *)kLineLayers{
    if (!_kLineLayers) {
        _kLineLayers = [NSMutableArray array];
    }
    return _kLineLayers;
}

- (NSMutableArray *)volumeLineLayers{
    if (!_volumeLineLayers) {
        _volumeLineLayers = [NSMutableArray array];
    }
    return _volumeLineLayers;
}

@end
