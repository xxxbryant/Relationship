//
//  RelationshipVC.m
//  All-History
//
//  Created by HD-XXZQ-iMac on 2019/10/24.
//  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
//

#import "RelationshipVC.h"
#import "PetalMainView.h"
#import "PetalView.h"

#import "RelationItemView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface RelationshipVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *sc;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) PetalMainView *petalView;
@property (nonatomic, strong) RelationItemView *relationView;
@end

@implementation RelationshipVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgView];
    
    _sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _sc.showsVerticalScrollIndicator = NO;
    _sc.showsHorizontalScrollIndicator = NO;
    _sc.backgroundColor = [UIColor clearColor];
    _sc.delegate = self;
    _sc.maximumZoomScale = 3;
    _sc.minimumZoomScale = 0.5;
    [self.view addSubview:_sc];
    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 100 , kScreenHeight * 100)];
    _bgView.backgroundColor = [UIColor clearColor];
    
    [_sc addSubview:_bgView];
    [_sc setContentOffset:CGPointMake(_bgView.center.x - kScreenWidth * 0.5 , _bgView.center.y - kScreenHeight * 0.5)  animated:YES];
    
    _relationView = [[RelationItemView alloc] initWithFrame:CGRectMake(0, 0, 90,90) withDegree:0];
    [_relationView setupCenterView:0 withURL:@"space_star"];
    _relationView.center = _bgView.center;
    _relationView.deflectRadius = 0;
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        [items addObject:[NSNumber numberWithInt:i]];
    }
    _relationView.subItems = items;
    [_bgView addSubview:_relationView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _sc.contentSize = CGSizeMake(kScreenWidth *100 , kScreenHeight*100);
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentSize.width);
    return _bgView;
}

@end
