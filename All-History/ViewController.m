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
}

- (void)buttonPressed:(UIButton *)btn
{
    [_sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
        RelationshipVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RelationshipVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [self.sphereView timerStart];
        }];
    }];
}

@end
