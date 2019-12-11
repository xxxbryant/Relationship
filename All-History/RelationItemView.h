//
//  RelationItemView.h
//  All-History
//
//  Created by HD-XXZQ-iMac on 2019/12/7.
//  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PetalView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RelationItemView : UIView<CAAnimationDelegate>

@property (nonatomic, assign) NSInteger degree;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint farPoint;
@property (nonatomic, assign) CGFloat nearDistance;
@property (nonatomic, assign) CGFloat endDistance;
@property (nonatomic, assign) CGFloat farDistance;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat deflectRadius;   // 偏转角度
@property (nonatomic, strong) PetalView *mainView;
@property (nonatomic, strong) NSMutableArray *subItems;
@property (nonatomic, strong) NSMutableArray <RelationItemView *> *itemViews;
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *dashLines;
@property (nonatomic, strong) CAShapeLayer  *dashLine;
@property (nonatomic, assign) BOOL isExpend;
@property (nonatomic, assign) CGFloat scale;
//- (void)setMenuItems:(NSArray *)menuItems;

- (void)expend:(BOOL)isExpend;
- (instancetype)initWithFrame:(CGRect)frame withDegree:(NSInteger)degree;
- (void)setupCenterView:(NSInteger)type withURL:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
