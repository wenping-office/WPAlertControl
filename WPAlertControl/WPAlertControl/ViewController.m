//
//  ViewController.m
//  WPAlertControl
//
//  Created by Developer on 2019/3/25.
//  Copyright © 2019 Developer. All rights reserved.
//

#import "ViewController.h"
#import "WPAlertControl.h"
#import "WPView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WPView *view1 = [WPView viewWithTapClick:^(id other) {
        
        // 快速创建一个item弹框 items 可以是 @[@"string",@"string"] 也可以是 @[@[@"string"],@[@"string"]]
        //[WPAlertControl alertItemsForRootControl:<#(UIViewController *)#> animateType:<#(WPAlertAnimateType)#> items:<#(NSArray *)#> index:<#^NSArray<WPAlertGroup *> *(NSInteger index, NSUInteger alertLevel, WPAlertControl *alertControl)index#>]
        //        到中心只需要设置 constant == -1
        [self itemsAlert];
    }];
    view1.text = @"item弹框";
    
    WPView *view2 = [WPView viewWithTapClick:^(id other) {
        [self bottemAlert];
    }];
    view2.text = @"底部弹框";
    
    WPView *view3 = [WPView viewWithTapClick:^(id other) {
        [self rightAlert];
    }];
    view3.text = @"右边弹框";
    
    WPView *view4 = [WPView viewWithTapClick:^(id other) {
        [self centerAlert];
    }];
    view4.text = @"中心弹框";
    
    WPView *view5 = [WPView viewWithTapClick:^(id other) {
        [self leftAlert];
    }];
    view5.text = @"左边弹框";
    
    WPView *view6 = [WPView viewWithTapClick:^(id other) {
        [self topAlert];
    }];
    view6.text = @"顶部弹框";
    
    view1.backgroundColor = [UIColor purpleColor];
    view2.backgroundColor = [UIColor purpleColor];
    view3.backgroundColor = [UIColor purpleColor];
    view4.backgroundColor = [UIColor purpleColor];
    view5.backgroundColor = [UIColor purpleColor];
    view6.backgroundColor = [UIColor purpleColor];
    
    view1.frame = CGRectMake(50, 50, 100, 100);
    view2.frame = CGRectMake(self.view.frame.size.width - 150, view1.frame.origin.y, 100, 100);
    view3.frame = CGRectMake(50, 200, 100, 100);
    view4.frame = CGRectMake(view2.frame.origin.x, view3.frame.origin.y, 100, 100);
    view5.frame = CGRectMake(view1.frame.origin.x, 350, 100, 100);
    view6.frame = CGRectMake(view4.frame.origin.x, view5.frame.origin.y, 100, 100);
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    [self.view addSubview:view5];
    [self.view addSubview:view6];
}

- (void)moveCenter
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    WPView *view1 = [WPView viewWithTapClick:^(id other) {
        
        [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {
            
            WPView *view2 = [WPView viewWithTapClick:^(id other) {
                [WPAlertControl alertHiddenForRootControl:self completion:nil];
            }];
            view2.frame = CGRectMake(0, 0, screenSize.width, 300);
            view2.backgroundColor = [UIColor blueColor];
            [alertControl setPushView:view2];
            
        }];
        
    }];
    view1.frame = CGRectMake(0, 0, screenSize.width, 150);
    view1.backgroundColor = [UIColor redColor];
    
    [WPAlertControl alertForView:view1 begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateDefault constant:-1 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self mackClick:nil animateStatus:nil];
}

- (void)centerAlert
{
    WPView *view1 = [WPView viewWithTapClick:^(id other) {
        
        [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {
            
            WPView *view2 = [WPView viewWithTapClick:^(id other) {
                [WPAlertControl alertHiddenForRootControl:self completion:nil];
            }];
            view2.frame = CGRectMake(0, 0, 200,200 );
            view2.backgroundColor = [UIColor blueColor];
            [alertControl setPushView:view2];
            
        }];
        
    }];
    view1.frame = CGRectMake(0, 0, 150, 150);
    view1.backgroundColor = [UIColor redColor];
    
    [WPAlertControl alertForView:view1 begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self mackClick:nil animateStatus:nil];
}

- (void)bottemAlert
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    WPView *view1 = [WPView viewWithTapClick:^(id other) {
        
        [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {
            WPView *view2 = [WPView viewWithTapClick:^(id other) {
                [WPAlertControl alertHiddenForRootControl:self completion:nil];
            }];
            view2.frame = CGRectMake(0, 0, screenSize.width, 300);
            view2.backgroundColor = [UIColor blueColor];
            [alertControl setPushView:view2];
        }];
    }];
    view1.frame = CGRectMake(0, 0, screenSize.width, 150);
    view1.backgroundColor = [UIColor redColor];
    
    [WPAlertControl alertForView:view1 begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateDefault constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

- (void)rightAlert
{
    WPView *view1 = [WPView viewWithTapClick:^(id other) {
        
        [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {
            
            WPView *view2 = [WPView viewWithTapClick:^(id other) {
                [WPAlertControl alertHiddenForRootControl:self completion:nil];
            }];
            view2.frame = CGRectMake(0, 0, 150, 150);
            view2.backgroundColor = [UIColor blueColor];

            [alertControl setPushView:view2 begin:WPAlertBeginBottem end:WPAlertEndCenter animateType:WPAlertAnimateDefault pan:NO constant:0];
        }];
        
    }];
    view1.frame = CGRectMake(0, 0, 200, 200);
    view1.backgroundColor = [UIColor redColor];
    
    [WPAlertControl alertForView:view1 begin:WPAlertBeginRight end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:-1 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self mackClick:nil animateStatus:nil];
}

- (void)leftAlert
{
    
    WPView *view1 = [WPView viewWithTapClick:^(id other) {
        
        [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {
            
            WPView *view2 = [WPView viewWithTapClick:^(id other) {
                [WPAlertControl alertHiddenForRootControl:self completion:nil];
            }];
            view2.frame = CGRectMake(0, 0, 150, 150);
            view2.backgroundColor = [UIColor blueColor];
            [alertControl setPushView:view2];
        }];
        
    }];
    view1.frame = CGRectMake(0, 0, 200, 200);
    view1.backgroundColor = [UIColor redColor];
    
    [WPAlertControl alertForView:view1 begin:WPAlertBeginLeft end:WPAlertEndRight animateType:WPAlertAnimateBounce constant:-1 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self mackClick:nil animateStatus:nil];
}

- (void)topAlert
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    WPView *view1 = [WPView viewWithTapClick:^(id other) {
        
        [WPAlertControl alertHiddenForRootControl:self completion:^(WPAlertShowStatus status, WPAlertControl *alertControl) {

            WPAlertItem *item1 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
                cell.textLabel.text = @"男";
                cell.detailTextLabel.text = @"子标题";
                cell.detailTextLabel.textColor = [UIColor redColor];
            }];
            
            WPAlertItem *item2 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
                cell.textLabel.text = @"女";
                cell.detailTextLabel.text = @"子标题";
            }];
            WPAlertGroup *group = [WPAlertGroup groupForTitle:@"请问您性别?" items:@[item1,item2]];
            
            [alertControl setPushItems:@[group] pushItemsClick:^NSArray<WPAlertGroup *> *(NSInteger index, NSUInteger alertLevel, WPAlertControl *alertControl) {
                
                WPView *view2 = [WPView viewWithTapClick:^(id other) {
                    [WPAlertControl alertHiddenForRootControl:self completion:nil];
                }];
                view2.frame = CGRectMake(0, 0, screenSize.width*0.5, 150);
                view2.backgroundColor = [UIColor blueColor];
                
                [alertControl setPushView:view2 begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce pan:YES constant:0];

                return nil;
            }];
            
        }];
        
    }];
    view1.frame = CGRectMake(0, 0, screenSize.width, 200);
    view1.backgroundColor = [UIColor redColor];
    
    [WPAlertControl alertForView:view1 begin:WPAlertBeginTop end:WPAlertEndTop animateType:WPAlertAnimateDefault constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self mackClick:nil animateStatus:nil];
}

- (void)itemsAlert
{
    WPAlertItem *item1 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
        cell.textLabel.text = @"男";
        cell.detailTextLabel.text = @"子标题";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }];
    
    WPAlertItem *item2 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
        cell.textLabel.text = @"女";
        cell.detailTextLabel.text = @"子标题";
    }];
    WPAlertGroup *group = [WPAlertGroup groupForTitle:@"请问您性别?" items:@[item1,item2]];
    
    [WPAlertControl alertForItems:@[group] index:^NSArray<WPAlertGroup *> *(NSInteger index, NSUInteger alertLevel, WPAlertControl *alertControl) {
        return [self groupsForAlertLeve:alertLevel index:index];
    } begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateDefault constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:NO rootControl:self mackClick:nil animateStatus:nil];
    
}

- (NSArray *)groupsForAlertLeve:(NSUInteger)level index:(NSUInteger)index
{
    
    if (level == 1) { // 第一次弹框
        if (index == 0) { // 选择了男
            WPAlertItem *i0 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
                cell.textLabel.text = @"撸代码";
            }];
            WPAlertItem *i1 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
                cell.textLabel.text = @"睡觉";
            }];
            WPAlertItem *i2 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
                cell.textLabel.text = @"打游戏";
            }];
            WPAlertGroup *g = [WPAlertGroup group:@[i0,i1,i2]];
            g.groupView.text = @"请问您喜欢什么?";
            return @[g];
            
        }else if (index==1){ // 选择了女
            WPAlertItem *i0 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
                cell.textLabel.text = @"买衣服";
            }];
            
            WPAlertItem *i1 = [WPAlertItem itemSettingCell:^(WPAlertControlCell *cell) {
                cell.textLabel.text = @"吃喝";
                cell.detailTextLabel.text = @"子标题";
            }];
            
            WPAlertGroup *g = [WPAlertGroup group:@[i0,i1]];
            g.groupView.text = @"请问您喜欢什么?";
            return @[g];
        }
    }else if (level == 2){ // 第二次弹框
        
        WPAlertItem *item = [WPAlertItem item:@"弹框"];
        
        WPAlertGroup *g = [WPAlertGroup group:@[item]];
        g.groupView.text = @"多组弹框";
        g.groupView.textColor = [UIColor blueColor];
        WPAlertGroup *g1 = [WPAlertGroup group:@[item,item]];
        g1.groupView.text = @"支持多层级弹框";
        g1.groupView.textColor = [UIColor redColor];
        return @[g,g1];
    }
    
    return nil;
}

@end
