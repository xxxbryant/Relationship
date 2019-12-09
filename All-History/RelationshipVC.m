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
//    [self test];
    _sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _sc.backgroundColor = [UIColor whiteColor];
    _sc.delegate = self;
    _sc.maximumZoomScale = 3;
    _sc.minimumZoomScale = 0.5;
    [self.view addSubview:_sc];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 2, kScreenHeight * 3)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_sc addSubview:_bgView];
    
    _relationView = [[RelationItemView alloc] initWithFrame:CGRectMake(0, 0, 200,200) withDegree:0];
    _relationView.center = _bgView.center;
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<6; i++) {
        [items addObject:[NSNumber numberWithInt:i]];
    }
    _relationView.subItems = items;
    [_bgView addSubview:_relationView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _sc.contentSize = CGSizeMake(kScreenWidth * 2 , kScreenHeight * 3);
}

- (void)addMinItemsView:(RelationItemView *)relationView {
    NSMutableArray *minItems = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        RelationItemView * p = [[RelationItemView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//        [_sc addSubview:p];
        [minItems addObject:p];
    }
//    [_relationView setMenuItems:minItems];
}

- (void)test {
    _petalView = [[PetalMainView alloc] initWithFrame:CGRectMake(kScreenWidth*0.5 - 100, 200, 200, 200)];
    _petalView.backgroundColor = [UIColor clearColor];
    NSMutableArray *items = [NSMutableArray array];
    
    for (int i=0; i<4; i++) {
        PetalView * p = [[PetalView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [items addObject:p];
    }
    
    [_petalView setMenuItems:items];
    [self.view addSubview:_petalView];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _bgView;
}

//
//// called before the scroll view begins zooming its content缩放开始的时候调用
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
////    NSLog(@"%s",__func__);
//}
//
//// scale between minimum and maximum. called after any 'bounce' animations缩放完毕的时候调用。
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//
//{
//    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
//    NSLog(@"scale is %f",scale);
//    [_sc setZoomScale:scale animated:YES];
//}
//
//// 缩放时调用
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    // 可以实时监测缩放比例
//    NSLog(@"......scale is %f",_sc.zoomScale);
//
//}


@end
