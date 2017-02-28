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
#import <mach/mach_time.h>

@interface ViewController ()<DXTopScrollViewDelegate>

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, strong) DXKLinePainter *painter;

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

    
    DXTopScrollView *topScroll = [[DXTopScrollView alloc]initWithFrame:paintRect];
    topScroll.topScrollDelegate = self;
    [self.view addSubview:topScroll];
    
    //test
    [DXkLineModelArray sharedInstance].arrayCount = models.chartlist.count;
}

- (void)topScrollView:(DXTopScrollView *)topScroll startIndex:(NSInteger)startIndex{

    DXkLineModelArray *models = [DXkLineModelArray sharedInstance];
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    // calculate all visiable line
    NSInteger visableCount = config.painterWidth / (config.kLineWidth + config.layerToLayerGap);
    // get max volume
    NSRange range = NSMakeRange(startIndex, visableCount);
    if ((startIndex + visableCount) > [DXkLineModelArray sharedInstance].chartlist.count) return;
    // time consuming 0.13 ms
    uint64_t start = mach_absolute_time();
    CGFloat maxVolume = [models calculateMaxVolumeIndexWithRange:range];
    config.maxVolume = maxVolume;
    // get max high min low
    maxAndHigh max = [models calculateMaxHightMinLowWithRange:range];
    config.maxHigh = max.maxHigh;
    config.minLow = max.minLow;
    maxAndHigh maxMACD = [models calculateMaxAndMinMACDWithRange:range];
    config.macdHighest = maxMACD.maxHigh;
    config.macdLowest = maxMACD.minLow;
    uint64_t end = mach_absolute_time();
    uint64_t elapsed = end - start;mach_timebase_info_data_t info;
    if (mach_timebase_info (&info) != KERN_SUCCESS)
    {
        printf ("mach_timebase_info failed\n");
    }
    uint64_t nanosecs = elapsed * info.numer / info.denom;
    double millisecs = (double)nanosecs / 1000000;
    NSLog(@">>>>>>>>>>cost time = %.3lf ms", millisecs);
    
    [_painter reloadWithModels:[[DXkLineModelArray sharedInstance].chartlist  subarrayWithRange:NSMakeRange(startIndex, visableCount)]];
    
}

@end
