//
//  PetalView.h
//  All-History
//
//  Created by HD-XXZQ-iMac on 2019/10/24.
//  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PetalView : UIView

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint farPoint;

@end

NS_ASSUME_NONNULL_END
