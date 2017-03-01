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
///上一次长按的Y坐标
@property (nonatomic,assign) CGFloat lastPressY;

@end

@implementation DXTopScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _crossInterval = 2;
        _lastPressY = [DXkLineModelConfig sharedInstance].painterTopHeight;
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
    CGFloat contentWidth = self.minMoveWidth * [DXkLineModelArray sharedInstance].arrayCount;
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
    BOOL isValid = [self isValidEvent:crossPoint];
    NSInteger crossIndex = (NSInteger)((crossPoint.x - self.contentOffset.x) / self.minMoveWidth);
    
    [self private_timerInvalidate];
    self.isShowCross = YES;
    if (crossGesture.state == UIGestureRecognizerStateChanged){
        CGFloat positionY = crossPoint.y;
        //处理Y轴情况
        if (!isValid) {
            positionY = self.lastPressY;
        }
        self.lastPressY = positionY;
        //越界判断
        if (positionY < 0) {
            positionY = 0;
        }else if(positionY > [DXkLineModelConfig sharedInstance].painterHeight){
            positionY = [DXkLineModelConfig sharedInstance].painterHeight;
        }
//         NSLog(@"positionY %f",positionY);
        
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollView:tapIndex:YPosition:)]) {
            [self.topScrollDelegate topScrollView:self tapIndex:crossIndex YPosition:positionY];
        }
        
    }else if(crossGesture.state == UIGestureRecognizerStateBegan){
        
        if (!isValid) {
            self.isShowCross = NO;
            return;
        }
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
    DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    CGPoint tapPoint = [tap locationInView:self];
    if (![self isValidEvent:tapPoint]) {
        return;
    }
    [self private_timerInvalidate];
    //轻点 触发十字线
    if (self.isShowCross) {
        self.isShowCross = !self.isShowCross;
//        NSLog(@"tap disapper");
        if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollViewHiddenCross)]) {
            [self.topScrollDelegate topScrollViewHiddenCross];
        }
        
    }else{
        //轻点下面的画布
        if (tapPoint.y > (config.painterHeight - config.painterBottomHeight)) {
//            NSLog(@"点击了底部");
            if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(tapBottomPainter)]) {
                [self.topScrollDelegate tapBottomPainter];
            }
        }else{
            CGPoint crossPoint = [tap locationInView:self];
//            NSInteger crossIndex = [self private_getRoundFromPoint:crossPoint];
            NSInteger crossIndex = (NSInteger)((crossPoint.x - self.contentOffset.x) / self.minMoveWidth);
            NSLog(@"tap start  %ld",crossIndex);
            if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollView:tapIndex:YPosition:)]) {
                [self.topScrollDelegate topScrollView:self tapIndex:crossIndex YPosition:crossPoint.y];
            }
            //开始计时
            [[NSRunLoop currentRunLoop]addTimer:self.crossTimer forMode:NSDefaultRunLoopMode];
            self.isShowCross = !self.isShowCross;
        }
        
    }
}

//手势位置是否合法
- (BOOL)isValidEvent:(CGPoint)eventPoint{
   DXkLineModelConfig *config = [DXkLineModelConfig sharedInstance];
    BOOL isValid;
    if (eventPoint.y > config.painterTopHeight && eventPoint.y < (config.painterHeight - config.painterBottomHeight)) {
        isValid = NO;
    }else{
        isValid = YES;
    }
    return isValid;
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
        //如果超出,则从下一个角标开始计算
        CGFloat countF = self.contentOffset.x / self.minMoveWidth;
        NSInteger startIndex = (NSInteger)(self.contentOffset.x / self.minMoveWidth);
        (countF - startIndex) > 0 ? startIndex++ : startIndex ;
        
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
    
//    if (!((self.frame.size.width - count * minWidth) < [DXkLineModelConfig sharedInstance].kLineWidth)) {
//        count++;
//    }
    return count;
}

- (CGFloat)minMoveWidth{
    return [DXkLineModelConfig sharedInstance].kLineWidth + [DXkLineModelConfig sharedInstance].layerToLayerGap;
}

- (NSTimer *)crossTimer{
    if (nil == _crossTimer) {
        _crossTimer = [NSTimer timerWithTimeInterval:_crossInterval repeats:NO block:^(NSTimer * _Nonnull timer) {
            
//            NSLog(@"自动消失");
            if (self.topScrollDelegate && [self.topScrollDelegate respondsToSelector:@selector(topScrollViewHiddenCross)]) {
                [self.topScrollDelegate topScrollViewHiddenCross];
            }
            _crossTimer = nil;
            _isShowCross = NO;
        }];
    }
    return _crossTimer;
}

@end
