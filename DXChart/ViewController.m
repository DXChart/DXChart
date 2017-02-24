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

@interface ViewController ()

@property (nonatomic, assign) CGFloat layerToLayerGap;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat width;

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
    CGFloat topMargin = 2;
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    config.painterMidGap = 10;
    config.painterTopHeight = 110;
    config.painterBottomHeight = 55;
    CGFloat height = config.painterBottomHeight+config.painterTopHeight+config.painterMidGap;

    config.painterHeight = height;
    config.kLineWidth = 5;
    config.painterWidth = self.view.frame.size.width - 2 *_margin;
    // 消除左边多余出来的 x - _width/2.
    DXBasePainter *painter = [[DXBasePainter alloc] initWithFrame:CGRectMake(_margin , 100, config.painterWidth, height + topMargin)];
    [self.view addSubview:painter];
    
    // calculate all visiable line
    NSInteger visableCount = painter.frame.size.width / (config.kLineWidth + config.layerToLayerGap);
    
    //get max volume
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
    
    // add kline ,volume
    for (int i = 0 ; i < visableCount; i ++) {
        
        DXVolumeLayer *volumeLayershapeLayer = [DXVolumeLayer layer];
        [volumeLayershapeLayer setLayerWithModel:models.chartlist[i] index:i];
        [painter.layer addSublayer:volumeLayershapeLayer];
        
        DXKLineLayer *kLineshapeLayer = [DXKLineLayer layer];
        [kLineshapeLayer setLayerWithModel:models.chartlist[i] index:i];
        [painter.layer addSublayer:kLineshapeLayer];
    }
    
    // add border
    DXBorderLayer *topBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, 0, config.painterWidth, config.painterTopHeight)];
    DXBorderLayer *bottomBorder = [DXBorderLayer layerWithFrame:CGRectMake(0, config.painterBottomToTop, config.painterWidth, config.painterBottomHeight)];
    [painter.layer addSublayer:topBorder];
    [painter.layer addSublayer:bottomBorder];
    
}


@end
