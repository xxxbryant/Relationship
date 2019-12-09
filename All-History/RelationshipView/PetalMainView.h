//
//  PetalMainView.h
//  All-History
//
//  Created by HD-XXZQ-iMac on 2019/10/24.
//  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PetalView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PetalMainView : UIView <CAAnimationDelegate>

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint farPoint;
@property (nonatomic, assign) CGFloat nearDistance;
@property (nonatomic, assign) CGFloat endDistance;
@property (nonatomic, assign) CGFloat farDistance;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, copy) NSArray *menuItems;
@property (nonatomic, strong) NSMutableArray *layerItems;
@property (nonatomic, strong) PetalView *mainView;

@property (nonatomic, assign) BOOL isExpend;

- (void)setMenuItems:(NSArray *)menuItems;
- (void)expend:(BOOL)isExpend;
@end

NS_ASSUME_NONNULL_END
