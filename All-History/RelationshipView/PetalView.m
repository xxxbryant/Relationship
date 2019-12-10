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
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 20)];
        [self.title setTextColor:[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0]];
        [self.title setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:self.title];
        [self.title setHidden:YES];
    }
    return self;
}



@end
