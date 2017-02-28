//
//  DXKLinePainter.m
//  DXChart
//
//  Created by caijing on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXKLinePainter.h"
#import <mach/mach_time.h>

@interface DXKLinePainter ()

@property (nonatomic, strong) NSMutableArray<DXKLineLayer *> *kLineLayers;
@property (nonatomic, strong) NSMutableArray<DXVolumeLayer *> *volumeLineLayers;
@property (nonatomic, strong) NSMutableArray<DXLineLayer *> *MALineLayers;
@property (nonatomic, strong) NSMutableArray<DXMACDLayer *> *macdColLineLayers;
@property (nonatomic, strong) NSMutableArray<DXLineLayer *> *macdLineLayers;

@end

@implementation DXKLinePainter

- (void)clearContent{
    [self clearMA];
    [self clearKLine];
    [self clearVolume];
    [self clearMACD];
    
}
- (void)clearMA{
    for (DXLineLayer *lay in _MALineLayers) {
        [lay clearPath];
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

- (void)clearMACD{
    for (DXBaseLayer *lay in _macdColLineLayers) {
        lay.path = NULL;
    }
    for (DXLineLayer * lay in _macdLineLayers) {
        [lay clearPath];
    }
}



- (void)reloadWithModels:(NSArray<DXkLineModel *> *)models{
#pragma warning - 这个地方需要确定下是否需要已有kLineLayers，伪代码
    /**
     maxCount >= kLineLayers.count >= minCount
     volumeLineLayers用上
     */    
    // add kline ,volume
    for (int i = 0 ; i < models.count; i ++) {
        /**
         如果没有则每个都到数组里面去
         有的话&数量相同则取出来更新
         不同的话是否需要补足？还是直接取最大数
         
         */
        if (!i) {[self clearContent];};//DXMACDLayer
// volume line
//        DXVolumeLayer *volumeLayershapeLayer = self.volumeLineLayers[i];
//        [volumeLayershapeLayer setLayerWithModel:models[i] index:i];
        // macd
        DXMACDLayer *macdLayer = self.macdColLineLayers[i];
        [macdLayer setLayerWithModel:models[i] index:i];
        
        DXKLineLayer *kLineshapeLayer = self.kLineLayers[i];
        [kLineshapeLayer setLayerWithModel:models[i] index:i];
        
        // MA
        [self.MALineLayers[0] setLayerWithModel:models[i] index:i];
        [self.MALineLayers[1] setLayerWithModel:models[i] index:i];
        [self.MALineLayers[2] setLayerWithModel:models[i] index:i];
        [self.MALineLayers[3] setLayerWithModel:models[i] index:i];
        // MACD Line
        [self.macdLineLayers[0] setLayerWithModel:models[i] index:i];
        [self.macdLineLayers[1] setLayerWithModel:models[i] index:i];
        
        if (i == (models.count - 1)){
            [self.MALineLayers[0] finishDrawPath];
            [self.MALineLayers[1] finishDrawPath];
            [self.MALineLayers[2] finishDrawPath];
            [self.MALineLayers[3] finishDrawPath];
            [self.macdLineLayers[0] finishDrawPath];
            [self.macdLineLayers[1] finishDrawPath];
        }
        
    }
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

        [self.layer addSublayer:ma5Line ];
        [self.layer addSublayer:ma10Line ];
        [self.layer addSublayer:ma20Line ];
        [self.layer addSublayer:ma30Line];

    }
    return _MALineLayers;
}

- (NSMutableArray *)kLineLayers{
    if (!_kLineLayers) {
        _kLineLayers = [NSMutableArray array];
        @autoreleasepool {
            // use max count
            for (int i = 0; i < 180; i++) {
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
            for (int i = 0; i < 180; i++) {
                DXVolumeLayer *volumeShapeLayer = [DXVolumeLayer layer];
                [_volumeLineLayers addObject:volumeShapeLayer];
                [self.layer addSublayer:volumeShapeLayer];
            }
        }
    }
    return _volumeLineLayers;
}

- (NSMutableArray<DXMACDLayer *> *)macdColLineLayers{
    if (!_macdColLineLayers) {
        _macdColLineLayers = [NSMutableArray array];
        @autoreleasepool {
            // use max count
            for (int i = 0; i < 180; i++) {
                DXMACDLayer *volumeShapeLayer = [DXMACDLayer layer];
                [_macdColLineLayers addObject:volumeShapeLayer];
                [self.layer addSublayer:volumeShapeLayer];
            }
        }
    }
    return _macdColLineLayers;
}

- (NSMutableArray<DXLineLayer *> *)macdLineLayers{
    if (!_macdLineLayers) {
        _macdLineLayers = [NSMutableArray array];
        @autoreleasepool {
            // use max count
            for (int i = 0; i < 180; i++) {
                DXLineLayer *difLine = [DXLineLayer layerWithType:DXLineTypeDIF];
                DXLineLayer *deaLine = [DXLineLayer layerWithType:DXLineTypeDEA];
                [_macdLineLayers addObject:difLine];
                [_macdLineLayers addObject:deaLine];
                [self.layer addSublayer:difLine];
                [self.layer addSublayer:deaLine];
            }
        }
    }
    return _macdLineLayers;
}

@end
