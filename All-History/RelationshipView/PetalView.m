//
//  PetalView.m
//  All-History
//
//  Created by HD-XXZQ-iMac on 2019/10/24.
//  Copyright © 2019 HD-XXZQ-iMac. All rights reserved.
//

#import "PetalView.h"

@implementation PetalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}



@end
