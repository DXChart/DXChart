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
 @param startIndex 开始的位置
 */
- (void) topScrollView:(DXTopScrollView *)topScroll startIndex:(NSInteger)startIndex;

@end

@interface DXTopScrollView : UIScrollView

@property (nonatomic,weak) id<DXTopScrollViewDelegate> topScrollDelegate;

@end
