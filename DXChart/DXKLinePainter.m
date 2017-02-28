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
@property (nonatomic, strong) NSMutableArray<UILabel *> *kLineLabels;
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
        if (!i) {[self clearContent];};
        // volume line
        if (self.chartType & DXChartTypeVolume){
            DXVolumeLayer *volumeLayershapeLayer = self.volumeLineLayers[i];
            [volumeLayershapeLayer setLayerWithModel:models[i] index:i];
        }

        // macd
        if (self.chartType & DXChartTypeMACD){
            DXMACDLayer *macdLayer = self.macdColLineLayers[i];
            [macdLayer setLayerWithModel:models[i] index:i];
        }
        
        // kLine
        if (self.chartType & DXChartTypeKline) {
            DXKLineLayer *kLineshapeLayer = self.kLineLayers[i];
            [kLineshapeLayer setLayerWithModel:models[i] index:i];
        }
        
        // MA
        if (self.chartType & DXChartTypeMA) {
            [self.MALineLayers[0] setLayerWithModel:models[i] index:i];
            [self.MALineLayers[1] setLayerWithModel:models[i] index:i];
            [self.MALineLayers[2] setLayerWithModel:models[i] index:i];
            [self.MALineLayers[3] setLayerWithModel:models[i] index:i];
        }
        
        // MACD Line
        if (self.chartType & DXChartTypeMACD) {
            [self.macdLineLayers[0] setLayerWithModel:models[i] index:i];
            [self.macdLineLayers[1] setLayerWithModel:models[i] index:i];
        }
        
        
        if (i == (models.count - 1)){
            // MA
            if (self.chartType & DXChartTypeMA) {
                [self.MALineLayers[0] finishDrawPath];
                [self.MALineLayers[1] finishDrawPath];
                [self.MALineLayers[2] finishDrawPath];
                [self.MALineLayers[3] finishDrawPath];
            }
            // MACD Line
            if (self.chartType & DXChartTypeMACD) {
                [self.macdLineLayers[0] finishDrawPath];
                [self.macdLineLayers[1] finishDrawPath];
            }
        }
        
    }
}


- (void)addBorder{
    // 后期可能需要更具chartType来更换
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    // add dash
    DXDashLayer *dashLayer1 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4.)];
    DXBaseLayer *midLineLayer = [DXBaseLayer layer];
    midLineLayer.frame = CGRectMake(0, config.painterTopHeight / 2., config.painterWidth, 0.5);
    midLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    DXDashLayer *dashLayer2 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 3.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 3.)];
    DXDashLayer *dashLayer3 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 5. + config.painterMidGap) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 5. + config.painterMidGap)];
    // add border
    DXBorderLayer *topBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, 0, config.painterWidth, config.painterTopHeight)];
    DXBorderLayer *bottomBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, config.painterBottomToTop, config.painterWidth, config.painterBottomHeight)];
    // notice: 有顺序
    [self.layer addSublayer:topBorder];
    [self.layer addSublayer:bottomBorder];
    [self.layer addSublayer:dashLayer1];
    [self.layer addSublayer:dashLayer2];
    [self.layer addSublayer:midLineLayer];
    [self.layer addSublayer:dashLayer3];
}

#pragma mark - Getter & Setter
// 后期有可能更换成 CATextLayer
- (NSMutableArray<UILabel *> *)kLineLabels{
    if (!_kLineLabels){
        _kLineLabels = [NSMutableArray array];
        CGFloat labelHeight = 10;
        DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
        for (int i = 0; i < 5; i ++) {
            UILabel *label  = [[UILabel alloc] init];
            label.hidden = YES;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:9.];
            CGFloat Y = (config.painterTopHeight - labelHeight) / 4. * i;
            if (i == 1) Y -= 2;
            if (i == 3) Y += 2;
            label.frame = CGRectMake(1, Y, 30, labelHeight);
            [self addSubview:label];
            [_kLineLabels addObject:label];
        }
    }
    return _kLineLabels;
}

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
        // use max count
        DXLineLayer *difLine = [DXLineLayer layerWithType:DXLineTypeDIF];
        DXLineLayer *deaLine = [DXLineLayer layerWithType:DXLineTypeDEA];
        [_macdLineLayers addObject:difLine];
        [_macdLineLayers addObject:deaLine];
        [self.layer addSublayer:difLine];
        [self.layer addSublayer:deaLine];
    }
    return _macdLineLayers;
}

@end
