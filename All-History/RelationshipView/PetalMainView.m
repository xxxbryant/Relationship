//
//  PetalMainView.m
//  All-History
//
//  Created by HD-XXZQ-iMac on 2019/10/24.
//  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
//

#import "PetalMainView.h"

@implementation PetalMainView 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.startPoint = CGPointMake(100, 100);
        // 修改这时的参数来调整大圆与圆之间的距离
        self.nearDistance = 30;
        self.farDistance = 100;
        self.endDistance = 80;
        self.scale = 1;
        [self addSubview:self.mainView];
    }
    return self;
}

- (void)setMenuItems:(NSArray *)menuItems {
    if (_menuItems != menuItems) {
        _menuItems = menuItems;
        
        for (UIView *v in self.subviews) {
            if (v.tag >= 1000) {
                [v removeFromSuperview];
            }
        }
        
        // add the menu buttons
        int count = (int)[menuItems count];
        CGFloat cnt = 1;
        for (int i = 0; i < count; i ++) {
            PetalView *item = [menuItems objectAtIndex:i];
            item.tag = 1000 + i;
            item.startPoint = self.startPoint;
            CGFloat pi =  M_PI / count;
            CGFloat endRadius = item.bounds.size.width / 2 + self.endDistance + _mainView.bounds.size.width / 2;
            CGFloat nearRadius = item.bounds.size.width / 2 + self.nearDistance + _mainView.bounds.size.width / 2;
            CGFloat farRadius = item.bounds.size.width / 2 + self.farDistance + _mainView.bounds.size.width / 2;
            item.endPoint = CGPointMake(self.startPoint.x + endRadius * sinf(pi * cnt),
                                        self.startPoint.y - endRadius * cosf(pi * cnt));
            item.nearPoint = CGPointMake(self.startPoint.x + nearRadius * sinf(pi * cnt),
                                         self.startPoint.y - nearRadius * cosf(pi * cnt));
            item.farPoint = CGPointMake(self.startPoint.x + farRadius * sinf(pi * cnt),
                                        self.startPoint.y - farRadius * cosf(pi * cnt));
            item.center = item.startPoint;
            [self addSubview:item];
            [self drawDashLine:item.startPoint point:item.endPoint];
            cnt += 2;
        }
        
        [self bringSubviewToFront:_mainView];
    }
}


- (void)expend:(BOOL)isExpend {
    _isExpend = isExpend;
    for (int i=0; i<self.menuItems.count; i++) {
        PetalView *obj = self.menuItems[i];
        CAShapeLayer *layer = self.layerItems[i];
        if (self.scale) {
            if (isExpend) {
                obj.transform = CGAffineTransformIdentity;
            } else {
                obj.transform = CGAffineTransformMakeScale(0.001, 0.001);
            }
        }
        [self addRotateAndPostisionForItem:obj toShow:isExpend];
        [self layerAnimation:layer toShow:isExpend];
    }
}

- (void)addRotateAndPostisionForItem:(PetalView *)item toShow:(BOOL)show {
    if (show) {
        CABasicAnimation *scaleAnimation = nil;
        if (self.scale) {
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0.2];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
            scaleAnimation.duration = 1.5f;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        }
        
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = @[@(M_PI), @(0.0)];
        rotateAnimation.duration = 1.5f;
        rotateAnimation.keyTimes = @[@(0.3), @(0.4)];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 1.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
//        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        if (self.scale) {
            animationgroup.animations = @[scaleAnimation, rotateAnimation,positionAnimation];
        } else {
            animationgroup.animations = @[positionAnimation, rotateAnimation];
        }
        animationgroup.duration = 1.5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:animationgroup forKey:@"Expand"];
        item.center = item.endPoint;
        
    } else {
        CABasicAnimation *scaleAnimation = nil;
        if (self.scale) {
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:0.2];
            scaleAnimation.duration = 1.5f;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        }
        
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = @[@0, @(M_PI * 2), @(0)];
        rotateAnimation.duration = 1.5f;
        rotateAnimation.keyTimes = @[@0, @(0.4), @(0.5)];
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 1.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
//        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        if (self.scale) {
            animationgroup.animations = @[scaleAnimation,  rotateAnimation,positionAnimation];
        } else {
            animationgroup.animations = @[positionAnimation, rotateAnimation];
        }
        
        animationgroup.duration = 1.5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:animationgroup forKey:@"Close"];
        item.center = item.startPoint;
    }
}

- (void)expend {
    _isExpend = !_isExpend;
    [self expend:_isExpend];
}


- (PetalView *)mainView {
    if (_mainView == nil) {
        _mainView = [[PetalView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _mainView.center = CGPointMake(100, 100);
        _mainView.backgroundColor = [UIColor yellowColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expend)];
        [_mainView addGestureRecognizer:tap];
        [self addSubview:_mainView];
    }
    return _mainView;
}

- (NSMutableArray *)layerItems {
    if (_layerItems == nil) {
        _layerItems = [NSMutableArray array];
    }
    return _layerItems;
}


- (void)drawDashLine:(CGPoint)startPoint point:(CGPoint)endPoint  {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path setLineWidth:2];
    CGFloat dash[] = {8.0,4.0,16.0,8.0};
    [path setLineDash:dash count:6 phase:2];
    [path stroke];
    [path fill];
    CAShapeLayer *layer = [CAShapeLayer new];
    [layer setPath:[path CGPath]];
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.strokeColor = [[UIColor redColor] CGColor];
    layer.lineWidth = 5.0;
    [self.layer insertSublayer:layer atIndex:0];
    [self.layerItems addObject:layer];
    [layer setHidden:YES];
    
}

- (void)layerAnimation:(CAShapeLayer *)layer toShow:(BOOL)show {
    if(show) {
        [layer setHidden:NO];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        animation.duration = 1.5;
        [layer addAnimation:animation forKey:nil];
//        layer.strokeEnd = 1.0;
    } else {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(1.0);
        animation.toValue = @(0.0);
        animation.duration = 2.0;
        animation.delegate = self;
        [layer addAnimation:animation forKey:nil];
//        layer.strokeEnd = 0.0;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"yes");
    [self.layerItems enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        [obj setHidden:YES];
        //        [obj removeFromSuperlayer];
    }];
}

@end
