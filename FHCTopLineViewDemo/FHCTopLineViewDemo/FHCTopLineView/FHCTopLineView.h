//
//  FHCTopLineView.h
//  FutureHowe
//
//  Created by hunuo on 2017/7/20.
//  Copyright © 2017年 fhc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FHCTopLineView;

@protocol FHCTopLineViewDelegate <NSObject>

@optional


/**
 点击滚动文字回调

 @param topLine FHCTopLineView
 @param index 选中文字的index
 */
- (void)topLineView:(FHCTopLineView *)topLine didSelectItemAtIndex:(NSInteger)index;


/**
 文字滚动的回调

 @param topLine FHCTopLineView
 @param index 滚动到的位置index
 */
- (void)topLineView:(FHCTopLineView *)topLine didScrollToIndex:(NSInteger)index;

@end

@interface FHCTopLineView : UIView


///////////////////////////  滚动控制接口 ///////////////////////////////

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 是否允许用户拖动，默认Yes */
@property (nonatomic, assign) BOOL enableDrag;

/** 文字滚动方向，默认为垂直滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<FHCTopLineViewDelegate> delegate;

///////////////////////////// 数据源接口 ////////////////////////////////////

/** 数据源数组 */
@property (nonatomic, strong) NSArray *titlesGroup;

@end
