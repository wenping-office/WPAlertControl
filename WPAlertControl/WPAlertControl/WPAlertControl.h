//
//  WPAlertControl.h
//  Rider
//
//  Created by Developer on 16/3/22.
//  Copyright © 2016年 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

// 隐藏弹框
#define WPAlertHidden(target) [WPAlertControl alertHiddenForRootControl:(target) completion:nil]

/** 开始枚举类型 */
typedef NS_ENUM(NSUInteger, WPAlertBeginType){
    WPAlertBeginLeft,
    WPAlertBeginRight,
    WPAlertBeginTop,
    WPAlertBeginBottem,
    WPAlertBeginCenter, // 中心弹出类型动画
} ;

/** 结束枚举类型 */
typedef NS_ENUM(NSUInteger, WPAlertEndType){
    WPAlertEndLeft,
    WPAlertEndRight,
    WPAlertEndTop,
    WPAlertEndBottem,
    WPAlertEndCenter,
};

/** 蒙版显示状态 */
typedef NS_ENUM(NSUInteger, WPAlertShowStatus){
    WPAnimateWillAppear, // 即将显示
    WPAnimateDidAppear, // 显示完成
    WPAnimateWillDisappear,// 即将消失
    WPAnimateDidDisappear, // 消失完成
};

/** 动画类型 */
typedef NS_ENUM(NSUInteger, WPAlertAnimateType){
    WPAlertAnimateDefault, // 默认
    WPAlertAnimateBounce, // 弹跳动画
};

@class WPAlertControl,WPAlertItem,WPAlertGroup,WPAlertControlCell;
typedef BOOL(^MaskClickBlock)(NSInteger index,NSUInteger alertLevel,WPAlertControl *alertControl);
typedef void(^AlertAnimateStatus)(WPAlertShowStatus status,WPAlertControl *alertControl);
typedef NSArray <WPAlertGroup *>* (^ItemClick)(NSInteger index,NSUInteger alertLevel,WPAlertControl *alertControl);
typedef void(^setttingControlCell)(WPAlertControlCell *cell);

#define alertTimeBeginInterval 0.3
#define alertTimeEndInterval 0.4
#define alertDefaultMaskColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

@interface WPAlertControl : UIViewController

/** 创建一个弹框
 * animateView 动画视图 animateView的size必须有值
 * begin 视图开始弹出的类型
 * endType 动画结束弹出的类型
 * constant 常量 默认0 -1==居中 动画结束时候的frame+上常量 可以微调动画结束后的frame
 * beginInterval 视图弹出的持续时间
 * endInterval 视图结束弹出的时间
 * masColor 蒙版的颜色
 * pan 是否支持拖动隐藏
 * rootControl alert弹出试图的根控制器
 * masClick 蒙版点击执行 return YES 蒙版不会消失 NO蒙版消失 默认YES
 * animateStatus alert弹框的当前状态 即将显示 -> 显示完成 -> 即将消失 -> 消失完成
 * alertLevel 当前动画的等级 默认为1 设置了pushAnimateView后会累加
 * animateType 动画类型
 */
+ (instancetype)alertForView:(UIView *)animateView begin:(WPAlertBeginType)type end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType constant:(CGFloat)constant animageBeginInterval:(CGFloat)beginInterval animageEndInterval:(CGFloat)endInterval maskColor:(UIColor *)color  pan:(BOOL)pan rootControl:(UIViewController *)rootControl  maskClick:(MaskClickBlock)click animateStatus:(AlertAnimateStatus)animateStatus;

/** 创建一个item选择弹框
 * items 菜单内容
 * index item 点击的索引
 * constant 常量 默认0 -1==居中 动画结束时候的frame+上常量 可以微调动画结束后的frame 当begin==end的时候有效
 * beginInterval 视图弹出的持续时间
 * endInterval 视图结束弹出的时间
 * masColor 蒙版的颜色
 * pan 是否支持拖动隐藏
 * rootControl alert弹出试图的根控制器
 * masClick 蒙版点击执行 return NO蒙版不会消失 YES蒙版消失 默认YES
 * animateStatus alert弹框的当前状态 即将显示 -> 显示完成 -> 即将消失 -> 消失完成
 * alertLevel 当前动画的等级 默认为1 设置了pushAnimateView后会累加
 */
+ (instancetype)alertForItems:(NSArray <WPAlertGroup *>*)items index:(ItemClick)index begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType constant:(CGFloat)constant animageBeginInterval:(CGFloat)beginInterval animageEndInterval:(CGFloat)endInterval maskColor:(UIColor *)color pan:(BOOL)pan rootControl:(UIViewController *)rootControl maskClick:(MaskClickBlock)click animateStatus:(AlertAnimateStatus)animateStatus;

/** 弹框消失 */
+ (void)alertHiddenForRootControl:(UIViewController *)control completion:(AlertAnimateStatus)completion;

/** 获得当前的弹框控制器 */
+ (instancetype)currentAlertControFor:(UIViewController *)rootControl;

/** 设置下个Items */
- (void)setPushItems:(NSArray <WPAlertGroup *>*)items pushItemsClick:(ItemClick)click;

/** 设置下个视图 */
- (void)setPushView:(UIView *)pushView;

/** 设置下个视图 */
- (void)setPushView:(UIView *)pushView begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType;

/** 设置下个视图 */
- (void)setPushView:(UIView *)pushView begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType pan:(BOOL)pan constant:(CGFloat)constant;

/** 设置下个视图 */
- (void)setPushView:(UIView *)pushView begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType pan:(BOOL)pan constant:(CGFloat)constant animageBeginInterval:(CGFloat)beginInterval animageEndInterval:(CGFloat)endInterval;


@end

/** 扩展创建方法 */
@interface WPAlertControl (WPExtension)
/** 创建一个items弹框 items 可以是 @[@"string",@"string"] 也可以是二维数组 @[@[@"string",@"string"],@[@"string",@"string"]]*/
+ (instancetype)alertItemsForRootControl:(UIViewController *)rootControl animateType:(WPAlertAnimateType)animateType items:(NSArray *)items index:(ItemClick)index;
@end

@interface WPAlertGroup : NSObject
+ (instancetype)group:(NSArray<WPAlertItem *>*)items;
+ (instancetype)groupForTitle:(NSString *)title items:(NSArray<WPAlertItem *>*)items;
@property (nonatomic,strong) NSArray <WPAlertItem *>*items;
@property (nonatomic,strong) UILabel *groupView;
@property (nonatomic,assign) CGFloat groupHeight;
@end

@interface WPAlertItem : NSObject
@property (nonatomic,assign) CGFloat cellHeight;

+ (instancetype)itemSettingCell:(setttingControlCell)cellBlock;
+ (instancetype)item:(NSString *)title;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) UITableViewCellSelectionStyle style;

@property (nonatomic,copy) setttingControlCell settingCell;

@end

@interface WPAlertControlCell : UITableViewCell
@property (nonatomic,strong) WPAlertItem *item;
@end












