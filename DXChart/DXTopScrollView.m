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
@end

@implementation DXTopScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self private_setupUI];
        [self private_setKVO];
        
    }
    return self;
}

- (void)private_setupUI{
    self.delegate = self;
    self.bounces = NO;
    self.decelerationRate = 0.8;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    //pinch gesture
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pinchGesture:)];
    [self addGestureRecognizer:pinch];
}

- (void)private_setKVO{
    [[DXkLineModelArray sharedInstance] addObserver:self forKeyPath:@"arrayCount" options:NSKeyValueObservingOptionNew context:nil];
    [[DXkLineModelConfig sharedInstance] addObserver:self forKeyPath:@"kLineWidth" options:NSKeyValueObservingOptionNew context:nil];

}
- (void)private_setContentSize{
    DXkLineModelConfig *modelConfig = [DXkLineModelConfig sharedInstance];
    CGFloat minMoveWidth = modelConfig.kLineWidth + modelConfig.layerToLayerGap;
    
    CGFloat contentWidth = minMoveWidth * ([DXkLineModelArray sharedInstance].arrayCount - 1) + modelConfig.kLineWidth;
    self.contentSize = CGSizeMake(contentWidth, [DXkLineModelConfig sharedInstance]. painterHeight);

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass: [DXkLineModelConfig class]] || [object isKindOfClass:[DXkLineModelArray class]]) {
        DXkLineModelConfig *modelConfig = [DXkLineModelConfig sharedInstance];
         CGFloat minMoveWidth = modelConfig.kLineWidth + modelConfig.layerToLayerGap;
        
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
            CGFloat contentOffX = startIndex * minMoveWidth;
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
        
        CGFloat minMoveWidth = [DXkLineModelConfig sharedInstance].kLineWidth + [DXkLineModelConfig sharedInstance].layerToLayerGap;
        
        NSInteger startIndex = (NSInteger)(self.contentOffset.x / minMoveWidth) - 1;
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

@end
