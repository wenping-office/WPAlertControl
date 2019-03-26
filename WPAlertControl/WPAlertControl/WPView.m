//
//  WPView.m
//  WPAlertControl
//
//  Created by Developer on 2019/3/25.
//  Copyright © 2019 Developer. All rights reserved.
//

#import "WPView.h"

@implementation WPView

+ (instancetype)viewWithTapClick:(block)tap
{
    WPView *view = [self new];
    view.tap = tap;
    return view;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)click:(UIGestureRecognizer *)gesture
{
    !self.tap ?:self.tap(gesture.view);
}

@end
