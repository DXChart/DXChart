//
//  ViewController.m
//  DXChart
//
//  Created by caijing on 17/2/23.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "ViewController.h"
#import "DXkLineModel.h"
#import "YYModel.h"
#import "DXBasePainter.h"
#import "DXkLineModelConfig.h"
#import "DXBaseLayer.h"
#import "DXBorderLayer.h"
#import "DXKLineLayer.h"
#import "DXDashLayer.h"
#import "DXVolumeLayer.h"
#import "DXLineLayer.h"
#import "DXTopScrollView.h"
#import "DXLayers.h"

@interface ViewController ()

@property (nonatomic, assign) CGFloat margin;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initial];

    
    
    
}

- (void)initial{
    // fetch data
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"kLineForDay" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    DXkLineModelArray *models = [DXkLineModelArray yy_modelWithDictionary:json];
    // normal
    _margin = 5;
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    config.painterMidGap = 10;
    config.painterTopHeight = 110;
    config.painterBottomHeight = 55;
    CGFloat height = config.painterBottomHeight+config.painterTopHeight+config.painterMidGap;

    config.painterHeight = height;
    config.kLineWidth = 5;
    config.painterWidth = self.view.frame.size.width - 2 *_margin;
    // 消除左边多余出来的 x - _width/2.

    CGRect paintRect = CGRectMake(_margin , 245, config.painterWidth, height + config.topMargin);
    
    DXBasePainter *painter = [[DXBasePainter alloc] initWithFrame:paintRect];

    [self.view addSubview:painter];
    
    DXTopScrollView *topScroll = [[DXTopScrollView alloc]initWithFrame:paintRect];
    [self.view addSubview:topScroll];
    
    //test
    [DXkLineModelArray sharedInstance].arrayCount = models.chartlist.count;
    
    //end
    
    // calculate all visiable line
    NSInteger visableCount = painter.frame.size.width / (config.kLineWidth + config.layerToLayerGap);
    
    // get max volume
    NSInteger maxIndex = [models calculateMaxVolumeIndexWithRange:NSMakeRange(0, visableCount)];
    DXkLineModel *maxModel = models.chartlist[maxIndex];
    config.maxVolume = maxModel.volume;
    // get max high min low
    maxAndHigh max = [models calculateMaxHightMinLowWithRange:NSMakeRange(0, visableCount)];
    config.maxHigh = max.maxHigh;
    config.minLow = max.minLow;

    // add dash
    DXDashLayer *dashLayer1 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4.)];
    DXBaseLayer *midLineLayer = [DXBaseLayer layer];
    midLineLayer.frame = CGRectMake(0, config.painterTopHeight / 2., config.painterWidth, 0.5);
    midLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    DXDashLayer *dashLayer2 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 3.) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 3.)];
    DXDashLayer *dashLayer3 = [DXDashLayer layerWithStartPoint:CGPointMake(0, config.painterTopHeight / 4. * 5. + config.painterMidGap) endPoint:CGPointMake(config.painterWidth, config.painterTopHeight / 4. * 5. + config.painterMidGap)];
    [painter.layer addSublayer:dashLayer1];
    [painter.layer addSublayer:dashLayer2];
    [painter.layer addSublayer:midLineLayer];
    [painter.layer addSublayer:dashLayer3];

    DXLineLayer *ma5Line = [DXLineLayer layerWithType:DXLineTypeMA5];
    DXLineLayer *ma10Line = [DXLineLayer layerWithType:DXLineTypeMA10];
    DXLineLayer *ma20Line = [DXLineLayer layerWithType:DXLineTypeMA20];
    DXLineLayer *ma30Line = [DXLineLayer layerWithType:DXLineTypeMA30];
    [painter.layer addSublayer:ma5Line];
    [painter.layer addSublayer:ma10Line];
    [painter.layer addSublayer:ma20Line];
    [painter.layer addSublayer:ma30Line];
    // add kline ,volume
    for (int i = 0 ; i < visableCount; i ++) {
        
        DXVolumeLayer *volumeLayershapeLayer = [DXVolumeLayer layer]; // 需要抽离
        [volumeLayershapeLayer setLayerWithModel:models.chartlist[i] index:i];
        [painter.layer addSublayer:volumeLayershapeLayer];
        
        DXKLineLayer *kLineshapeLayer = [DXKLineLayer layer]; // 需要抽离
        [kLineshapeLayer setLayerWithModel:models.chartlist[i] index:i];
        [painter.layer addSublayer:kLineshapeLayer];
        
        [ma5Line setLayerWithModel:models.chartlist[i] index:i];
        [ma10Line setLayerWithModel:models.chartlist[i] index:i];
        [ma20Line setLayerWithModel:models.chartlist[i] index:i];
        [ma30Line setLayerWithModel:models.chartlist[i] index:i];
        
        if (i == (visableCount - 1)){
            [ma5Line finishDrawPath];
            [ma30Line finishDrawPath];
            [ma20Line finishDrawPath];
            [ma10Line finishDrawPath];
        }
        
    }
    
    // add border
    DXBorderLayer *topBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, 0, config.painterWidth, config.painterTopHeight)];
    DXBorderLayer *bottomBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, config.painterBottomToTop, config.painterWidth, config.painterBottomHeight)];
    [painter.layer addSublayer:topBorder];
    [painter.layer addSublayer:bottomBorder];
    
}


@end
