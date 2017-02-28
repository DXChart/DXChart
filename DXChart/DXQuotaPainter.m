//
//  DXQuotaPainter.m
//  DXChart
//
//  Created by caijing on 17/2/28.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXQuotaPainter.h"

static const CGFloat kTopBarginHeight = 10;

@interface DXQuotaPainter ()

@property (nonatomic, strong) NSMutableArray<UILabel *> *kLineLabels;
@property (nonatomic, strong) NSMutableArray<UILabel *> *kLineDateLabels;
@property (nonatomic, weak  ) UILabel *bottomMidLabel;

@end

@implementation DXQuotaPainter

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // basic config
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self setUpUI];
        
    }
    return self;
}

- (void)reloadWithModels:(NSArray<DXkLineModel *> *)models{
    
    DXkLineModel *firstModel = models.firstObject;
    DXkLineModel *lastModel = models.lastObject;
    _kLineDateLabels[0].text = [firstModel.time.description substringToIndex:10];
    _kLineDateLabels[1].text = [lastModel.time.description substringToIndex:10];
    
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    for (int i = 0; i < 5; i++) {
        UILabel *label = self.kLineLabels[i];
        CGFloat total = config.highest - config.lowest;
        label.text = [NSString stringWithFormat:@"%.2lf",config.highest - i * total / 4.] ;
        label.hidden = !(self.chartType & DXChartTypeKline);
    }
    
    if (self.chartType & DXChartTypeMACD) {
        _bottomMidLabel.text = [NSString stringWithFormat:@"%.2lf",(config.macdHighest - config.macdLowest) / 2.];
    }
    if (self.chartType & DXChartTypeVolume) {
        _bottomMidLabel.text = [NSString stringWithFormat:@"%.2lf万",config.maxVolume / 2. /10000];
    }
}

- (void)setUpUI{
    CGFloat labelHeight = 10;
    _kLineLabels = @[].mutableCopy;
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    for (int i = 0; i < 5; i ++) {
        UILabel *label  = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:9.];
        CGFloat Y = (config.painterTopHeight - labelHeight) / 4. * i + kTopBarginHeight;
        if (i == 1) Y -= 2;
        if (i == 3) Y += 2;
        label.frame = CGRectMake(1, Y, 30, labelHeight);
        [self addSubview:label];
        [_kLineLabels addObject:label];

        
    }
    
    _kLineDateLabels = [NSMutableArray array];
    CGFloat dateLabelWidth = 100;
    for (int i = 0; i < 2; i++) {
        UILabel *label  = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:9.];
        if (i == 1) label.textAlignment = NSTextAlignmentRight;
        label.frame = CGRectMake(1 + (config.painterWidth - dateLabelWidth) * i, config.painterTopHeight + kTopBarginHeight + 1, dateLabelWidth, 10);
        [self addSubview:label];
        [_kLineDateLabels addObject:label];
    }
    
    UILabel *label  = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:9.];
    _bottomMidLabel = label;
    label.frame = CGRectMake(1, config.painterBottomToTop + 10 + config.painterBottomHeight/2. - 4.5, dateLabelWidth, 10);
    [self addSubview:label];
    
}

@end
