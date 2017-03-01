//
//  DXTopScrollView.m
//  DXChart
//
//  Created by diaochuan on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import "DXTopScrollView.h"
#import "DXkLineModel.h"
#import "DXkLineModelConfig.h"

@interface DXTopScrollView ()<UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat oldOffsetX;

@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger lastIndex;
@property (nonatomic,assign) NSInteger showCount;
@property (nonatomic,assign) BOOL isPinch;
@property (nonatomic,assign) CGFloat minMoveWidth;

@property (nonatomic,strong) NSTimer *crossTimer;

@property (nonatomic,assign) BOOL isShowCross;

@end

@implementation DXTopScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _crossInterval = 3;
        [self private_setupUI];
        [self private_setKVO];
        [self private_setGesture];
    }
    return self;
}

- (void)private_setupUI{
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.delegate = self;
    self.bounces = NO;
    self.decelerationRate = 0.8;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)private_setGesture{
    //pinch gesture
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pinchGesture:)];
    [self addGestureRecognizer:pinch];
    
    //tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event_tapGesture:)];
    [self addGestureRecognizer:tap];
    
    //longPress
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_crossGesture:)];
    [self addGestureRecognizer:longPress];
}

- (void)private_setKVO{
    [[DXkLineModelArray sharedInstance] addObserver:self forKeyPath:@"arrayCount" options:NSKeyValueObservingOptionNew context:nil];
    [[DXkLineModelConfig sharedInstance] addObserver:self forKeyPath:@"kLineWidth" options:NSKeyValueObservingOptionNew context:nil];

}
- (void)private_setContentSize{
    DXkLineModelConfig *modelConfig = [DXkLineModelConfig sharedInstance];
    
    CGFloat contentWidth = self.minMoveWidth * ([DXkLineModelArray sharedInstance].arrayCount - 1) + modelConfig.kLineWidth;
    self.contentSize = CGSizeMake(contentWidth, [DXkLineModelConfig sharedInstance]. painterHeight);

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass: [DXkLineModelConfig class]] || [object isKindOfClass:[DXkLineModelArray class]]) {
        BOOL isCountChange = [keyPath isEqualToString:@"arrayCount"];
        BOOL isLineWidthChange = [keyPath isEqualToString:@"kLineWidth"];
        if (isCountChange) {
            //update contentSize
            [self private_setContentSize];
            self.lastIndex = [DXkLineModelArray sharedInstance].arrayCount - 1;
            self.contentOffset = CGPointMake(self.contentSize.width - self.bounds.size.width, 0);
        }
        if (isLineWidthChange) {
            
            [self private_setContentSize];
            
            NSInteger startIndex = self.lastIndex - self.showCount + 1;
            startIndex < 0 ? startIndex = 0 : startIndex;
            CGFloat contentOffX = startIndex * self.minMoveWidth;
            self.isPinch = YES;
            if (self.startIndex == startIndex) {
                [self private_handlePich];
            }else{
                self.contentOffset = CGPointMake(contentOffX, 0);
            }
        }
    }
}

- (void)event_pinchGesture:(UIPinchGestureRecognizer *)pinch{

    CGFloat scaleFactor = [DXkLineModelConfig sharedInstance].ScaleFactor;
    CGFloat newScale = pinch.scale > 1.0 ? (1 + scaleFactor) : (1 - scaleFactor);
    [DXkLineModelConfig sharedInstance].scale *= newScale;
    CGFloat lineWidth = [DXkLineModelConfig sharedInstance].scale * [DXkLineModelConfig sharedInstance].kOriginLineWidth;
    if ([DXkLineModelConfig sharedInstance].kLineWidth == lineWidth) {
        return;
    }
    [DXkLineModelConfig sharedInstance].kLineWidth = lineWidth;

}
#pragma mark - crossGesture
- (void)event_crossGesture:(UILongPressGestureRecognizer *) crossGesture{
    CGPoint crossPoint = [crossGesture locationInView:self];
    NSInteger crossIndex = [self private_getRoundFromPoint:crossPoint];
    
    [self private_timerInvalidate];
    self.isShowCross = YES;
    if (crossGesture.state == UIGestureRecognizerStateChanged){
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollView:tapIndex:YPosition:)]) {
            [self.topScrollDelegate topScrollView:self tapIndex:crossIndex YPosition:crossPoint.y];
        }
        
    }else if(crossGesture.state == UIGestureRecognizerStateBegan){
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollViewHiddenCross)]) {
            [self.topScrollDelegate topScrollViewHiddenCross];
        }
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollView:tapIndex:YPosition:)]) {
            [self.topScrollDelegate topScrollView:self tapIndex:crossIndex YPosition:crossPoint.y];
        }
    }else {

        //开始计时 5秒消失
        [[NSRunLoop currentRunLoop] addTimer:self.crossTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)event_tapGesture:(UITapGestureRecognizer *)tap{
    [self private_timerInvalidate];
    if (self.isShowCross) {
        NSLog(@"tap disapper");
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollViewHiddenCross)]) {
            [self.topScrollDelegate topScrollViewHiddenCross];
        }

    }else{
        CGPoint crossPoint = [tap locationInView:self];
        NSInteger crossIndex = [self private_getRoundFromPoint:crossPoint];
        NSLog(@"tap start");
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollView:tapIndex:YPosition:)]) {
            [self.topScrollDelegate topScrollView:self tapIndex:crossIndex YPosition:crossPoint.y];
        }
        //开始计时
        [[NSRunLoop currentRunLoop]addTimer:self.crossTimer forMode:NSDefaultRunLoopMode];
        
    }
    self.isShowCross = !self.isShowCross;
}
#pragma mark - 四舍五入 获得X坐标位置
- (NSInteger)private_getRoundFromPoint:(CGPoint)crossPoint{
    
    CGFloat countFloat =  crossPoint.x / self.minMoveWidth;
    NSInteger crossIndex;
    if(countFloat - (NSInteger)countFloat < 0.5){
        crossIndex = (NSInteger)countFloat;
    }else{
        crossIndex = (NSInteger)countFloat + 1;
    }
    crossIndex--;
    return crossIndex;
}

- (void)private_timerInvalidate{
    [self.crossTimer invalidate];
    self.crossTimer = nil;
}

- (void)private_handlePich{
    self.isPinch = NO;
    self.startIndex = self.lastIndex - self.showCount;
    if (self.startIndex < 0) {
        self.startIndex = 0;
        self.lastIndex = self.showCount - 1;
    }
    if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollView:startIndex:)]) {
        [self.topScrollDelegate topScrollView:self startIndex:self.startIndex];
    }

}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isPinch) {
        [self private_handlePich];
    }else{
        
        NSInteger startIndex = (NSInteger)(self.contentOffset.x / self.minMoveWidth) - 1;
        startIndex < 0 ? startIndex = 0 : startIndex;
        
        NSInteger lastIndex = startIndex + self.showCount;
        //同样的数据 不需要调用代理
        if (self.startIndex == startIndex && self.lastIndex == lastIndex) {
            return;
        }
        
        self.lastIndex = lastIndex;
        self.startIndex = startIndex;
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollView:startIndex:)]) {
            [self.topScrollDelegate topScrollView:self startIndex:startIndex];
        }
    }
}



- (void)dealloc{
    [[DXkLineModelConfig sharedInstance] removeObserver:self forKeyPath:@"kLineWidth" ];
    [[DXkLineModelArray sharedInstance] removeObserver:self forKeyPath:@"arrayCount"];
}

#pragma mark - lazy
- (NSInteger)showCount{
    
    CGFloat minWidth = [DXkLineModelConfig sharedInstance].kLineWidth + [DXkLineModelConfig sharedInstance].layerToLayerGap;
    
    NSInteger count = (NSInteger)(self.frame.size.width / minWidth);
    
    if (!((self.frame.size.width - count * minWidth) < [DXkLineModelConfig sharedInstance].kLineWidth)) {
        count++;
    }
    return count;
}

- (CGFloat)minMoveWidth{
    return [DXkLineModelConfig sharedInstance].kLineWidth + [DXkLineModelConfig sharedInstance].layerToLayerGap;
}

- (NSTimer *)crossTimer{
    if (nil == _crossTimer) {
        _crossTimer = [NSTimer timerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            
            NSLog(@"自动消失");
            _crossTimer = nil;
            _isShowCross = NO;
        }];
    }
    return _crossTimer;
}

@end
