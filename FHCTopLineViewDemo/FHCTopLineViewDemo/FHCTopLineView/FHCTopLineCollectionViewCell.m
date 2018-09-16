//
//  FHCTopLineCollectionViewCell.m
//  FutureHowe
//
//  Created by hunuo on 2017/7/20.
//  Copyright © 2017年 fhc. All rights reserved.
//

#import "FHCTopLineCollectionViewCell.h"

@interface FHCTopLineCollectionViewCell ()

@property (nonatomic, retain) UILabel* titleLabel;

@end

@implementation FHCTopLineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTitleLabel];
    }
    return self;
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.titleLabel];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
}

@end
