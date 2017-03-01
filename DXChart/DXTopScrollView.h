//
//  DXTopScrollView.h
//  DXChart
//
//  Created by diaochuan on 17/2/24.
//  Copyright © 2017年 caijing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXTopScrollView;
@protocol DXTopScrollViewDelegate <NSObject>

/**
 手指滑动的距离(滑动的数据个数)

 @param topScroll topScroll
 @param startIndex 开始的位置(相对于可显示区域)
 */
- (void) topScrollView:(DXTopScrollView *)topScroll startIndex:(NSInteger)startIndex;

/**
 绘画十字线

 @param topScroll topScroll
 @param tapIndex X轴的数据开始位置
 @param YPosition Y轴的大小
 */
- (void) topScrollView:(DXTopScrollView *)topScroll tapIndex:(NSInteger)tapIndex YPosition:(CGFloat)YPosition;
/// 隐藏十字线通知
- (void) topScrollViewHiddenCross;
///点击下面成交量
- (void) tapBottomPainter;

@end

@interface DXTopScrollView : UIScrollView

@property (nonatomic,weak) id<DXTopScrollViewDelegate> topScrollDelegate;

@property (nonatomic,assign) NSTimeInterval crossInterval; //十字线消失时间 默认3秒

@end
