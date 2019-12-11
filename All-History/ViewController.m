//
//  ViewController.m
//  All-History
//
//  Created by HD-XXZQ-iMac on 2019/10/24.
//  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
//

#import "ViewController.h"
#import "DBSphereView.h"
#import "RelationshipVC.h"
#import "BezierPathView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) DBSphereView *sphereView;
@property (nonatomic, strong) CAShapeLayer *dashedLine;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bubble";
    CGFloat width = kScreenWidth - 60;
    _sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(30, 200, width, width)];
    _sphereView.backgroundColor = [UIColor clearColor];
    _sphereView.clipsToBounds = YES;
    _sphereView.layer.cornerRadius = width * 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space_star"]];
    imageView.layer.cornerRadius = width * 0.5;
    imageView.clipsToBounds = YES;
    imageView.frame = CGRectMake(10, 180, width + 40, width + 40);
    [self.view addSubview:imageView];

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 20; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[NSString stringWithFormat:@"Ppppppppdsadpp%ld", i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:24.];
        btn.frame = CGRectMake(0, 0, 80, 80);
        btn.titleLabel.numberOfLines = 0;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [_sphereView addSubview:btn];
    }
    [_sphereView setCloudTags:array];
    [self.view addSubview:_sphereView];
    [self drawDashLine];
//    [self drawLine];
}

BOOL isShow = true;

- (void)buttonPressed:(UIButton *)btn
{
    [_sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
        RelationshipVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RelationshipVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
//         [self addRotateAndPostisionForItem:isShow];
//        isShow = !isShow;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [self.sphereView timerStart];
        }];
    }];
}

- (void)drawDashLine {
    _dashedLine = [CAShapeLayer layer];
    [_dashedLine setFrame:CGRectMake(50, 600, 300 , 400)];

    // Setup the path
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, 0, 10);
    CGPathAddLineToPoint(thePath, NULL, 0, 100);
    _dashedLine.path = thePath;
    CGPathRelease(thePath);

    [_dashedLine setLineDashPattern: [NSArray arrayWithObjects:[NSNumber numberWithFloat:2], nil]];
    _dashedLine.lineWidth = 1.0f;
    _dashedLine.strokeColor =  [[UIColor redColor] CGColor];
    [self.view.layer addSublayer:self->_dashedLine];
    [_dashedLine setStrokeEnd:0];
}

- (void)drawLine {
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 5.0;
    
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [path moveToPoint:CGPointMake(500.0, 650.0)];//起点
    
    // Draw the lines
    [path addLineToPoint:CGPointMake(300.0, 100.0)];
    [path addLineToPoint:CGPointMake(260, 200)];
    [path addLineToPoint:CGPointMake(100.0, 200)];
    [path addLineToPoint:CGPointMake(100, 70.0)];
    [path closePath];//第五条线通过调用closePath方法得到的
    
    //    [path stroke];//Draws line 根据坐标点连线
    [path fill];//颜色填充
}


- (void)addRotateAndPostisionForItem:(BOOL)show {
    if (show) {
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @0;
        strokeAnimation.toValue = @1;
        strokeAnimation.duration = 5.f;
        strokeAnimation.removedOnCompletion = NO;
        strokeAnimation.fillMode = kCAFillModeForwards;
        [self.dashedLine addAnimation:strokeAnimation forKey:@"strokeAnimation"];
    } else {
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @1;
        strokeAnimation.toValue = @0;
        strokeAnimation.duration = 5.f;
        strokeAnimation.removedOnCompletion = NO;
        strokeAnimation.fillMode = kCAFillModeForwards;
        [self.dashedLine addAnimation:strokeAnimation forKey:@"strokeAnimation"];
    }
    
}


@end
