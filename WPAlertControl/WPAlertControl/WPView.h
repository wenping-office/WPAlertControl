//
//  WPView.h
//  WPAlertControl
//
//  Created by Developer on 2019/3/25.
//  Copyright © 2019 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^block)(id other);

NS_ASSUME_NONNULL_BEGIN

@interface WPView : UILabel
+ (instancetype)viewWithTapClick:(block)tap;

@property (nonatomic,copy) block tap;

@end

NS_ASSUME_NONNULL_END
