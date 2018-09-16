//
//  ViewController.m
//  FHCTopLineViewDemo
//
//  Created by fu on 2018/9/16.
//  Copyright © 2018年 fhc. All rights reserved.
//

#import "ViewController.h"
#import "FHCTopLineView.h"

#define screenWidth ([UIScreen mainScreen].bounds.size.width)
#define screenHeight ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<FHCTopLineViewDelegate>

@property (strong, nonatomic) UIView *contentView1;
@property (strong, nonatomic) FHCTopLineView *topLineView1;
@property (nonatomic, retain) FHCTopLineView * topLineView2;
@property (nonatomic, retain) FHCTopLineView * topLineView3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.contentView1];
    
    self.topLineView1 = [[FHCTopLineView alloc] initWithFrame:CGRectMake(70, 0, screenWidth-70, 50)];
    [self.contentView1 addSubview:self.topLineView1];
    self.topLineView1.delegate = self;
    self.topLineView1.titlesGroup = @[@"淘宝的广告上下滚动111",@"淘宝的广告上下滚动222",@"淘宝的广告上下滚动333"];
    
    self.topLineView2 = [[FHCTopLineView alloc] initWithFrame:CGRectMake(20, 170, screenWidth-40, 50)];
    self.topLineView2.autoScrollTimeInterval = 4.0;
    [self.view addSubview:self.topLineView2];
    self.topLineView2.titlesGroup = @[@"淘宝的广告上下滚动111",@"淘宝的广告上下滚动222",@"淘宝的广告上下滚动333"];
    
    self.topLineView3 = [[FHCTopLineView alloc] initWithFrame:CGRectMake(20, 240, screenWidth-40, 50)];
    self.topLineView3.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:self.topLineView3];
    self.topLineView3.titlesGroup = @[@"淘宝的广告上下滚动111",@"淘宝的广告上下滚动222",@"淘宝的广告上下滚动333"];
}

#pragma mark - **************** delegate
- (void)topLineView:(FHCTopLineView *)topLine didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectItemAtIndex= %ld",index);
}

- (void)topLineView:(FHCTopLineView *)topLine didScrollToIndex:(NSInteger)index {
    NSLog(@"didScrollToIndex = %ld",index);
}

- (UIView *)contentView1 {
    if (_contentView1 == nil) {
        _contentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 50)];
        UIImageView * logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLine"]];
        logoImageView.frame = CGRectMake(0, 0, 50, 50);
        [_contentView1 addSubview:logoImageView];
        
        UIImageView * imageView2 = [[UIImageView alloc] init];
        imageView2.backgroundColor = [UIColor lightGrayColor];
        imageView2.frame = CGRectMake(60, 10, 1, 30);
        [_contentView1 addSubview:imageView2];
    }
    return _contentView1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
