//
//  DXCrossLinePainter.m
//  DXChart
//
//  Created by caijing on 17/3/1.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXCrossLinePainter.h"

static CGFloat const klineWidth = 0.5;
static CGFloat const klabelHeight = 10.;
static CGFloat const klabelWidth = 30;
static CGFloat const kGap = (klabelHeight/2. - klineWidth/2.);

@interface DXCrossLinePainter ()

@property (nonatomic) DXLineLayer *baseLayer;
@property (nonatomic, weak  ) UILabel *leftQuotaLabel;

@end

@implementation DXCrossLinePainter

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIColor *alphaColor = [UIColor colorWithWhite:0 alpha:0];
        self.backgroundColor = alphaColor;
        _baseLayer = [DXLineLayer layer];
        _baseLayer.lineWidth = 0.5;
        _baseLayer.fillColor = alphaColor.CGColor;
        _baseLayer.strokeColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_baseLayer];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, klabelWidth, 10)];
        label.backgroundColor = alphaColor;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:9.];
        label.hidden = YES;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        _leftQuotaLabel = label;
        [self addSubview:label];
    }
    return self;
}

- (void)moveToIndex:(NSInteger)index y:(CGFloat)y{
    _baseLayer.path = NULL;
    [_baseLayer.strokePath removeAllPoints];
    _leftQuotaLabel.hidden = NO;
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    [_baseLayer.strokePath moveToPoint:CGPointMake([config getXPositionWithIndex:index] - klineWidth/2., config.painterTopHeight)];
    [_baseLayer.strokePath addLineToPoint:CGPointMake([config getXPositionWithIndex:index] - klineWidth/2., 0)];
    [_baseLayer.strokePath moveToPoint:CGPointMake(0+_leftQuotaLabel.frame.size.width , y)];
    [_baseLayer.strokePath addLineToPoint:CGPointMake(config.painterWidth, y)];
    [_baseLayer finishDrawPath];
    NSLog(@"%lf",y);
    if ( y <= config.painterTopHeight){
        if (y <= kGap ) {
            _leftQuotaLabel.frame = CGRectMake(0, 0, klabelWidth, klabelHeight);
        }else if (config.painterTopHeight - kGap <= y && y <= config.painterTopHeight){
            _leftQuotaLabel.frame = CGRectMake(0, config.painterTopHeight - klabelHeight, klabelWidth, klabelHeight);
        }else{
            _leftQuotaLabel.frame = CGRectMake(0, y - kGap, klabelWidth, klabelHeight);
        }
    }else{
        if (y <= (kGap + config.painterBottomToTop)) {
            _leftQuotaLabel.frame = CGRectMake(0, config.painterBottomToTop, klabelWidth, klabelHeight);
        }else if (config.painterHeight - kGap <= y <= config.painterHeight){
            _leftQuotaLabel.frame = CGRectMake(0, config.painterHeight - klabelHeight, klabelWidth, klabelHeight);
        }else{
            _leftQuotaLabel.frame = CGRectMake(0, y- kGap, klabelWidth, klabelHeight);
        }
    }
    _leftQuotaLabel.text =[NSString stringWithFormat:@"%.2f",[config getPriceWithYPosition:y]] ;
}

- (void)hiddenCrossLine{
    _baseLayer.path = NULL;
    [_baseLayer.strokePath removeAllPoints];
    _leftQuotaLabel.hidden = YES;
}

@end
