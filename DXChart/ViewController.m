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
#import "DXTopScrollView.h"
#import "DXLayers.h"
#import "DXKLinePainter.h"
#import <mach/mach_time.h>
#import "DXQuotaPainter.h"

@interface ViewController ()<DXTopScrollViewDelegate>

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, strong) DXKLinePainter *painter;
@property (nonatomic, strong) DXQuotaPainter *quotaPainter;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [self initial];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)initial{
    
    // fetch data
    DXkLineModelArray *models = [DXkLineModelArray sharedInstance];
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

    CGRect paintRect = CGRectMake(_margin , 255, config.painterWidth, height + config.topMargin);
    DXKLinePainter *painter = [[DXKLinePainter alloc] initWithFrame:paintRect];
    _painter = painter;
    [painter addBorder];
    [self.view addSubview:painter];
    
    DXQuotaPainter *quotaPainter = [[DXQuotaPainter alloc] initWithFrame:CGRectMake(_margin , 245, config.painterWidth, height + config.topMargin + 10)];
    quotaPainter.chartType = painter.chartType = DXChartTypeKline | DXChartTypeMA | DXChartTypeVolume;
    _quotaPainter = quotaPainter;
    [self.view addSubview:quotaPainter];
    

    
    DXTopScrollView *topScroll = [[DXTopScrollView alloc]initWithFrame:paintRect];
    topScroll.topScrollDelegate = self;
    [self.view addSubview:topScroll];
    //test
    [DXkLineModelArray sharedInstance].arrayCount = models.chartlist.count;
}

- (void)topScrollView:(DXTopScrollView *)topScroll startIndex:(NSInteger)startIndex{
    NSLog(@"index %ld",startIndex);
    DXkLineModelArray *models = [DXkLineModelArray sharedInstance];
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    // calculate all visiable line
    NSInteger visableCount = config.painterWidth / (config.kLineWidth + config.layerToLayerGap);
    // get max volume
    NSRange range = NSMakeRange(startIndex, visableCount);
    if ((startIndex + visableCount) > [DXkLineModelArray sharedInstance].chartlist.count) return;
    // time consuming 0.01~0.05 ms ,可以无视
    CGFloat maxVolume = [models calculateMaxVolumeIndexWithRange:range];
    config.maxVolume = maxVolume;
    // get max high min low
    maxAndHigh max = [models calculateMaxHightMinLowWithRange:range];
    config.maxHigh = max.maxHigh;
    config.minLow = max.minLow;
    maxAndHigh maxMACD = [models calculateMaxAndMinMACDWithRange:range];
    config.macdHighest = maxMACD.maxHigh;
    config.macdLowest = maxMACD.minLow;
    [_quotaPainter reloadWithModels:[[DXkLineModelArray sharedInstance].chartlist  subarrayWithRange:NSMakeRange(startIndex, visableCount)]];
    [_painter reloadWithModels:[[DXkLineModelArray sharedInstance].chartlist  subarrayWithRange:NSMakeRange(startIndex, visableCount)]];
    
}

@end
