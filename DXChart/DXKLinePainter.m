//
//  DXKLinePainter.m
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXKLinePainter.h"

@interface DXKLinePainter ()

@property (nonatomic, strong) NSMutableArray<DXKLineLayer *> *kLineLayers;
@property (nonatomic, strong) NSMutableArray<DXVolumeLayer *> *volumeLineLayers;
@property (nonatomic, strong) NSMutableArray<DXLineLayer *> *MALineLayers;

@end

@implementation DXKLinePainter

- (void)clearContent{
    [self clearMA];
    [self clearKLine];
    [self clearVolume];
    
}
- (void)clearMA{
    for (DXBaseLayer *lay in _MALineLayers) {
        lay.path = NULL;
    }
}
- (void)clearKLine{
    for (DXBaseLayer *lay in _kLineLayers) {
        lay.path = NULL;
    }
}
- (void)clearVolume{
    for (DXBaseLayer *lay in _volumeLineLayers) {
        lay.path = NULL;
    }
}


- (void)reloadWithModels:(NSArray<DXkLineModel *> *)models{
#pragma warning - 这个地方需要确定下是否需要已有kLineLayers，伪代码
    /**
     maxCount >= kLineLayers.count >= minCount
     volumeLineLayers用上
     */
    [super reloadWithModels:models];
    
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    
    // add kline ,volume
    for (int i = 0 ; i < models.count; i ++) {
        /**
         如果没有则每个都到数组里面去
         有的话&数量相同则取出来更新
         不同的话是否需要补足？还是直接取最大数
         */
        DXVolumeLayer *volumeLayershapeLayer = self.volumeLineLayers[i]; // 需要抽离
        [volumeLayershapeLayer setLayerWithModel:models[i] index:i];
        
        DXKLineLayer *kLineshapeLayer = self.kLineLayers[i]; // 需要抽离
        [kLineshapeLayer setLayerWithModel:models[i] index:i];
        
        [self.MALineLayers[0] setLayerWithModel:models[i] index:i];
        [self.MALineLayers[1] setLayerWithModel:models[i] index:i];
        [self.MALineLayers[2] setLayerWithModel:models[i] index:i];
        [self.MALineLayers[3] setLayerWithModel:models[i] index:i];
        
        if (i == (models.count - 1)){
            [self.MALineLayers[0] finishDrawPath];
            [self.MALineLayers[1] finishDrawPath];
            [self.MALineLayers[2] finishDrawPath];
            [self.MALineLayers[3] finishDrawPath];
        }
        
    }
    
    // add border
    DXBorderLayer *topBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, 0, config.painterWidth, config.painterTopHeight)];
    DXBorderLayer *bottomBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, config.painterBottomToTop, config.painterWidth, config.painterBottomHeight)];
    // notice: 有顺序
    [self.layer addSublayer:topBorder];
    [self.layer addSublayer:bottomBorder];
    [self.layer addSublayer:self.MALineLayers[0] ];
    [self.layer addSublayer:self.MALineLayers[1] ];
    [self.layer addSublayer:self.MALineLayers[2] ];
    [self.layer addSublayer:self.MALineLayers[3] ];
}

#pragma mark - Getter & Setter

- (NSMutableArray<DXLineLayer *> *)MALineLayers{
    if (!_MALineLayers) {
        _MALineLayers = [NSMutableArray array];
        DXLineLayer *ma5Line = [DXLineLayer layerWithType:DXLineTypeMA5];
        DXLineLayer *ma10Line = [DXLineLayer layerWithType:DXLineTypeMA10];
        DXLineLayer *ma20Line = [DXLineLayer layerWithType:DXLineTypeMA20];
        DXLineLayer *ma30Line = [DXLineLayer layerWithType:DXLineTypeMA30];
        [_MALineLayers addObject:ma5Line];
        [_MALineLayers addObject:ma10Line];
        [_MALineLayers addObject:ma20Line];
        [_MALineLayers addObject:ma30Line];
    }
    return _MALineLayers;
}

- (NSMutableArray *)kLineLayers{
    if (!_kLineLayers) {
        _kLineLayers = [NSMutableArray array];
        @autoreleasepool {
            // use max count
            for (int i = 0; i < 100; i++) {
                DXKLineLayer *kLineshapeLayer = [DXKLineLayer layer];
                [_kLineLayers addObject:kLineshapeLayer];
                [self.layer addSublayer:kLineshapeLayer];
            }
        }
    }
    return _kLineLayers;
}

- (NSMutableArray *)volumeLineLayers{
    if (!_volumeLineLayers) {
        _volumeLineLayers = [NSMutableArray array];
        @autoreleasepool {
            // use max count
            for (int i = 0; i < 100; i++) {
                DXVolumeLayer *volumeShapeLayer = [DXVolumeLayer layer];
                [_volumeLineLayers addObject:volumeShapeLayer];
                [self.layer addSublayer:volumeShapeLayer];
            }
        }
    }
    return _volumeLineLayers;
}

@end
