////
////  RelationItemView.m
////  All-History
////
////  Created by HD-XXZQ-iMac on 2019/12/7.
////  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
////
//
#import "RelationItemView.h"

@implementation RelationItemView

- (instancetype)initWithFrame:(CGRect)frame withDegree:(NSInteger)degree
{
    self = [super initWithFrame:frame];
    if (self) {
        // 修改这时的参数来调整大圆与圆之间的距离
        self.height = frame.size.height;
        self.width = frame.size.width;
        self.nearDistance = 20 - degree * 10;
        self.farDistance = 90  - degree * 90;
        self.endDistance = 90  - degree * 90;
        self.degree = degree;
        self.scale = 1;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupCenterView:(NSInteger)type withURL:(NSString *)url {
    _mainView = [[PetalView alloc] initWithFrame:CGRectMake(0, 0, self.height - 10, self.width - 10)];
    _mainView.center = self.center;
    if (self.degree == 1) {
        [_mainView setupImageView:[NSString stringWithFormat:@"%li_%li",(long)self.degree,(long)type]];
    }
    if (self.degree == 2) {
        _mainView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [_mainView setupImageView:[NSString stringWithFormat:@"%li_%li",(long)self.degree,(long)type]];
        _mainView.title.text = @"晋国鸟尊";
        [_mainView.title setHidden:NO];
    }
    if (url) {
        [_mainView setupImageView:url];
       }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expend)];
    [_mainView addGestureRecognizer:tap];
     [self addSubview:self.mainView];
}


- (void)setSubItems:(NSMutableArray *)subItems {
    if (_subItems != subItems) {
        _subItems = subItems;
        int count = (int)[subItems count];
        NSMutableArray *array = [@[@1,@2,@1,@2] mutableCopy];
        for (int i = 0; i < count; i ++) {
            RelationItemView *item = [[RelationItemView alloc] initWithFrame:CGRectMake(0, 0,self.height - 10 * (self.degree + 1), self.width - 10 * (self.degree + 1)) withDegree:self.degree + 1];
            [item setupCenterView:i withURL:nil];
            CGFloat pi = M_PI / 6 + (i%6) * M_PI / 3 ;
            item.startPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            CGFloat endRadius = item.bounds.size.width / 2 + self.endDistance + self.bounds.size.width / 2;
            CGFloat nearRadius = item.bounds.size.width / 2 + self.nearDistance + self.bounds.size.width / 2;
            CGFloat farRadius = item.bounds.size.width / 2 + self.farDistance + self.bounds.size.width / 2;
            if (i >= 6) {
                endRadius = item.bounds.size.width / 2 + self.endDistance + 150 * (self.degree + 1)  + self.bounds.size.width / 2;
                pi = (i%6 + 1) * M_PI / 3;
                nearRadius = item.bounds.size.width / 2 + self.nearDistance + 150  *  (self.degree + 1) + self.bounds.size.width / 2;
                farRadius = item.bounds.size.width / 2 + self.farDistance + 150 *  (self.degree + 1) + self.bounds.size.width / 2;
            }
            if (self.degree == 1) {
                pi =  2*i * M_PI / array.count  ;
            }
            pi = pi + self.deflectRadius;
            if (array.count > 6) {
                item.deflectRadius = pi - M_PI / 3 * array.count;
            } else {
                item.deflectRadius = pi - M_PI / 6 * array.count;
            }
            
            item.endPoint = CGPointMake(item.startPoint.x - endRadius * cosf(pi),item.startPoint.y - endRadius * sinf(pi));
            item.nearPoint = CGPointMake(item.startPoint.x - nearRadius * cosf(pi),item.startPoint.y - nearRadius * sinf(pi));
            item.farPoint = CGPointMake(item.startPoint.x - farRadius * cosf(pi),item.startPoint.y - farRadius * sinf(pi));
            item.center = item.startPoint;
            
            // 添加虚线
            CAShapeLayer *shapeLayer = [self drawDashLine:item.startPoint with:item.endPoint];
            item.dashLine = shapeLayer;
            [item.dashLines addObject:shapeLayer];
            
            [self addSubview:item];
            [self.itemViews addObject:item];
            
            if (self.degree == 0) {
                [item setSubItems:array];
            }
        }
        [self bringSubviewToFront:self.mainView];
    }
}

- (void)expend:(BOOL)isExpend {
    _isExpend = isExpend;
    for (int i=0; i<self.subItems.count; i++) {
        RelationItemView *obj = self.itemViews[i];
        if (self.scale) {
            if (isExpend) {
                obj.transform = CGAffineTransformIdentity;
                obj.mainView.transform = CGAffineTransformIdentity;
            } else {
                obj.transform = CGAffineTransformMakeScale(0.001, 0.001);
            }
        }
        [self addDashLineAnimation:obj toShow:isExpend];
        [self addRotateAndPostisionForItem:obj toShow:isExpend];
        
    }
}

- (void)addDashLineAnimation:(RelationItemView *)item toShow:(BOOL)show {
    if (show) {
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @0;
        strokeAnimation.toValue = @1;
        strokeAnimation.duration = 1.3f;
        strokeAnimation.removedOnCompletion = NO;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [item.dashLine addAnimation:strokeAnimation forKey:@"strokeAnimation"];
    } else {
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fromValue = @1;
        strokeAnimation.toValue = @0;
        strokeAnimation.duration = 1.3f;
        strokeAnimation.removedOnCompletion = NO;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [item.dashLine addAnimation:strokeAnimation forKey:@"strokeAnimation"];
    }
}

- (void)addRotateAndPostisionForItem:(RelationItemView *)item toShow:(BOOL)show {
    if (show) {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.2];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.duration = 1.5f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 1.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = @[positionAnimation, scaleAnimation];
        animationgroup.duration = 5.0f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [item.layer addAnimation:animationgroup forKey:@"Expand"];
        item.center = item.endPoint;
        
    } else {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.2];
        scaleAnimation.duration = 1.5f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 1.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = @[scaleAnimation,positionAnimation];
        animationgroup.duration = 1.5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [item.layer addAnimation:animationgroup forKey:@"Close"];
        item.center = item.startPoint;
    }
}

- (void)expend {
    _isExpend = !_isExpend;
    [self expend:_isExpend];
}

- (CAShapeLayer *)drawDashLine:(CGPoint)startPoint with:(CGPoint)endPoint {
    CAShapeLayer *dashedLine = [CAShapeLayer layer];
    // 这个大小决定着是否可以被绘制出来
    [dashedLine setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    // Setup the path
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(thePath, NULL, endPoint.x, endPoint.y);
    dashedLine.path = thePath;
    CGPathRelease(thePath);
    
    [dashedLine setLineDashPattern: [NSArray arrayWithObjects:[NSNumber numberWithFloat:2], nil]];
    dashedLine.lineWidth = 1.0f;
    dashedLine.strokeColor =  [[UIColor redColor] CGColor];
    [self.layer addSublayer:dashedLine];
    [dashedLine setStrokeEnd:0];
    return dashedLine;
}


//- (PetalView *)mainView {
//    if (_mainView == nil) {
//        _mainView = [[PetalView alloc] initWithFrame:CGRectMake(0, 0, self.height - 10, self.width - 10)];
//        _mainView.center = self.center;
//        _mainView.backgroundColor = [UIColor yellowColor];
//        if (self.degree == 1) {
//            _mainView.backgroundColor = [UIColor greenColor];
//        }
//        if (self.degree == 2) {
//            _mainView.transform = CGAffineTransformMakeScale(0.001, 0.001);
//            _mainView.backgroundColor = [UIColor purpleColor];
//            _mainView.title.text = @"晋国鸟尊";
//            [_mainView.title setHidden:NO];
//        }
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expend)];
//        [_mainView addGestureRecognizer:tap];
//    }
//    return _mainView;
//}

- (NSMutableArray<RelationItemView *> *)itemViews {
    if (_itemViews == nil) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
}

- (NSMutableArray<CAShapeLayer *> *)dashLines {
    if (_dashLines == nil) {
        _dashLines = [NSMutableArray array];
    }
    return _dashLines;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView*view = [super hitTest:point withEvent:event];
    if(view ==nil) {
        for(UIView*subView in self.subviews) {
            if ([subView isKindOfClass:[RelationItemView class]]) {
                CGPoint myPoint = [subView convertPoint:point fromView:self];
                if (CGRectContainsPoint(self.bounds, myPoint)) {
                    for(UIView*sub in subView.subviews) {
                        if ([sub isKindOfClass:[PetalView class]]) {
                            return sub;
                        }
                    }
                }
            }
        }
    }
    return view;
}

@end
