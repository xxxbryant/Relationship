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
//        self.startPoint = CGPointMake(100, 100);
//        // 修改这时的参数来调整大圆与圆之间的距离
        self.nearDistance = 30 / (degree + 1);
        self.farDistance = 100 / (degree + 1);
        self.endDistance = 80 / (degree + 1);
        self.degree = degree;
        self.height = frame.size.height;
        self.width = frame.size.width;
        self.scale = 1;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mainView];
    }
    return self;
}

- (void)setSubItems:(NSMutableArray *)subItems {
    if (_subItems != subItems) {
        _subItems = subItems;
        int count = (int)[subItems count];
        NSMutableArray *array = @[@1,@2];
        for (int i = 0; i < count; i ++) {
            RelationItemView *item = [[RelationItemView alloc] initWithFrame:CGRectMake(0, 0,100/ (self.degree + 1) - 10, 100/ (self.degree + 1) - 10) withDegree:self.degree + 1];
//            [array addObject:[NSNumber numberWithInt:i]];
           
            item.tag = 1000 + i;
            item.startPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
//            CGFloat pi = 2 * i * M_PI / count + M_PI / count ;
//            if (i>5) {
//                pi = M_PI / 6 + (i%6) * M_PI / 3;
//            }
            CGFloat pi = M_PI / 6 + (i%6) * M_PI / 3 ;
            CGFloat endRadius = item.bounds.size.width / 2 + self.endDistance + self.bounds.size.width / 2;
            
            CGFloat nearRadius = item.bounds.size.width / 2 + self.nearDistance + self.bounds.size.width / 2;
            CGFloat farRadius = item.bounds.size.width / 2 + self.farDistance + self.bounds.size.width / 2;
            if (i >= 6) {
                endRadius = item.bounds.size.width / 2 + self.endDistance + 150 + self.bounds.size.width / 2;
                pi = (i%6 + 1) * M_PI / 3;
                nearRadius = item.bounds.size.width / 2 + self.nearDistance + 150 + self.bounds.size.width / 2;
                farRadius = item.bounds.size.width / 2 + self.farDistance + 150 + self.bounds.size.width / 2;
            }
            item.endPoint = CGPointMake(item.startPoint.x - endRadius * cosf(pi),
                                        item.startPoint.y - endRadius * sinf(pi));
            
//            NSLog(@"item.endPoint: %f  itemIndex: %i", item.endPoint.x, i);
            item.nearPoint = CGPointMake(item.startPoint.x - nearRadius * cosf(pi),
                                         item.startPoint.y - nearRadius * sinf(pi));
            item.farPoint = CGPointMake(item.startPoint.x - farRadius * cosf(pi),
                                        item.startPoint.y - farRadius * sinf(pi));
            item.center = item.startPoint;
            [self addSubview:item];
            [self.itemViews addObject:item];
//            [self drawDashLine:item.startPoint point:item.endPoint];
            if (self.degree == 0) {
                [item setSubItems:array];
                
            }
        }
        [self bringSubviewToFront:self.mainView];
    }
}

//
//
- (void)expend:(BOOL)isExpend {
    _isExpend = isExpend;
    for (int i=0; i<self.subItems.count; i++) {
        RelationItemView *obj = self.itemViews[i];
        for (RelationItemView *s in obj.subviews) {
            if ([s isKindOfClass:[RelationItemView class]]) {
                [s expend:NO];
            }
        }
        if (self.scale) {
            if (isExpend) {
                obj.transform = CGAffineTransformIdentity;
            } else {
                obj.transform = CGAffineTransformMakeScale(0.001, 0.001);
            }
        }
        [self addRotateAndPostisionForItem:obj toShow:isExpend];
//        [self layerAnimation:layer toShow:isExpend];
    }
}
//
- (void)addRotateAndPostisionForItem:(RelationItemView *)item toShow:(BOOL)show {
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
        _mainView = [[PetalView alloc] initWithFrame:CGRectMake(0, 0, self.height / (self.degree + 1), self.height / (self.degree + 1))];
        _mainView.center = self.center;
        _mainView.backgroundColor = [UIColor yellowColor];
        if (self.degree == 1) {
            _mainView.backgroundColor = [UIColor greenColor];
        }
        if (self.degree == 2) {
            _mainView.backgroundColor = [UIColor purpleColor];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expend)];
        [_mainView addGestureRecognizer:tap];
    }
    return _mainView;
}

- (NSMutableArray<RelationItemView *> *)itemViews {
    if (_itemViews == nil) {
        _itemViews = [NSMutableArray array];
    }
    return _itemViews;
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
//                        CGPoint p = [sub convertPoint:myPoint fromView:subView];
//                        RelationItemView *s = (RelationItemView *)subView;
//                        if (CGRectContainsPoint(s.mainView.bounds, p)) {
//                            NSLog(@"%ld", (long)s.degree);
//                            return sub;
//                        }
                    }
                }
            }
        }
    }
    return view;
}

//
//
//- (void)drawDashLine:(CGPoint)startPoint point:(CGPoint)endPoint  {
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    [path addLineToPoint:endPoint];
//    [path setLineWidth:2];
//    CGFloat dash[] = {8.0,4.0,16.0,8.0};
//    [path setLineDash:dash count:6 phase:2];
//    [path stroke];
//    [path fill];
//    CAShapeLayer *layer = [CAShapeLayer new];
//    [layer setPath:[path CGPath]];
//    layer.fillColor = [[UIColor clearColor] CGColor];
//    layer.strokeColor = [[UIColor redColor] CGColor];
//    layer.lineWidth = 5.0;
//    [self.layer insertSublayer:layer atIndex:0];
//    [self.layerItems addObject:layer];
//    [layer setHidden:YES];
//    
//}
//
//- (void)layerAnimation:(CAShapeLayer *)layer toShow:(BOOL)show {
//    if(show) {
//        [layer setHidden:NO];
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.fromValue = @(0.0);
//        animation.toValue = @(1.0);
//        animation.duration = 1.5;
//        [layer addAnimation:animation forKey:nil];
////        layer.strokeEnd = 1.0;
//    } else {
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.fromValue = @(1.0);
//        animation.toValue = @(0.0);
//        animation.duration = 2.0;
//        animation.delegate = self;
//        [layer addAnimation:animation forKey:nil];
////        layer.strokeEnd = 0.0;
//    }
//}
//
//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    NSLog(@"yes");
//    [self.layerItems enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        //        [obj setHidden:YES];
//        //        [obj removeFromSuperlayer];
//    }];
//}
//
@end
//
