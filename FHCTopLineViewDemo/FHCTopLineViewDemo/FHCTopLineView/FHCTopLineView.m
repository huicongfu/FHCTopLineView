//
//  FHCTopLineView.m
//  FutureHowe
//
//  Created by hunuo on 2017/7/20.
//  Copyright © 2017年 fhc. All rights reserved.
//

#import "FHCTopLineView.h"
#import "FHCTopLineCollectionViewCell.h"
#import "UIView+SDExtension.h"

NSString * const cellID = @"cycleCell";

@interface FHCTopLineView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, retain) UICollectionView * mainCollectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) NSTimer * timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
/// 显示的标题数组
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation FHCTopLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
        [self createUI];
    }
    return self;
}

- (void)initialization {
    _autoScroll = YES;
    _infiniteLoop = YES;
    _autoScrollTimeInterval = 2.0;
    _enableDrag = YES;
}

- (void)createUI {
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout = flowLayout;
    
    UICollectionView * mainCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.pagingEnabled = YES;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    mainCollectionView.showsHorizontalScrollIndicator = NO;
    [mainCollectionView registerClass:[FHCTopLineCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.scrollsToTop = NO;
    mainCollectionView.scrollEnabled = _enableDrag;
    [self addSubview:mainCollectionView];
    _mainCollectionView = mainCollectionView;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FHCTopLineCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    if (_titlesGroup.count && itemIndex < _titlesGroup.count) {
        cell.titleStr = _titlesGroup[itemIndex];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(topLineView:didSelectItemAtIndex:)]) {
        long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
        [self.delegate topLineView:self didSelectItemAtIndex:itemIndex];
    }
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.titlesArray.count;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _flowLayout.itemSize = self.frame.size;
    _mainCollectionView.frame = self.bounds;
    
    if (_mainCollectionView.contentOffset.x == 0 && _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else {
            targetIndex = 0;
        }
        [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark -  UIScrollViewDelegate 

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (!self.imagePathsGroup.count) {
//        return;
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.mainCollectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.titlesArray.count) {// 解决清除timer时偶尔会出现的问题
        return;
    }
    int currentItem = [self currentIndex];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:currentItem];
    // 代理回调
    if ([self.delegate respondsToSelector:@selector(topLineView:didScrollToIndex:)]) {
        [self.delegate topLineView:self didScrollToIndex:itemIndex];
    }
}

#pragma mark -  actions

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setupTimer {
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll {
    if (0 == _totalItemsCount) {
        return;
    }
    
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
//            targetIndex = 0;
            [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex {
    if (_mainCollectionView.sd_width == 0 || _mainCollectionView.sd_height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainCollectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    }else {
        index = (_mainCollectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

#pragma mark -  setter

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    
    if (self.titlesArray.count) {
        self.titlesArray = self.titlesArray;
    }
}

- (void)setTitlesGroup:(NSArray *)titlesGroup {
    _titlesGroup = titlesGroup;
    
    self.titlesArray = titlesGroup;
    
}

- (void)setTitlesArray:(NSArray *)titlesArray {
    [self invalidateTimer];
    _titlesArray = titlesArray;
    
    _totalItemsCount = self.infiniteLoop ? self.titlesArray.count * 100 : self.titlesArray.count;
    
    if (titlesArray.count != 1) {
        if (self.enableDrag) {
            self.mainCollectionView.scrollEnabled = YES;
        }
        [self setAutoScroll:self.autoScroll];
    }else {
        self.mainCollectionView.scrollEnabled = NO;
    }
    [self.mainCollectionView reloadData];
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}

- (void)setEnableDrag:(BOOL)enableDrag {
    _enableDrag = enableDrag;
    self.mainCollectionView.scrollEnabled = enableDrag;
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainCollectionView.delegate = nil;
    _mainCollectionView.dataSource = nil;
    NSLog(@"滚动销毁啦--%s",__func__);
}

@end
