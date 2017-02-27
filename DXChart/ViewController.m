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
#import "DXKLinePainter.h"

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
    NSInteger visableCount = config.painterWidth / (config.kLineWidth + config.layerToLayerGap);
    
    // get max volume
    NSInteger maxIndex = [models calculateMaxVolumeIndexWithRange:NSMakeRange(0, visableCount)];
    DXkLineModel *maxModel = models.chartlist[maxIndex];
    config.maxVolume = maxModel.volume;
    // get max high min low
    maxAndHigh max = [models calculateMaxHightMinLowWithRange:NSMakeRange(0, visableCount)];
    config.maxHigh = max.maxHigh;
    config.minLow = max.minLow;

    [painter reloadWithModels:[models.chartlist subarrayWithRange:NSMakeRange(0, visableCount)]];
    
}


@end
