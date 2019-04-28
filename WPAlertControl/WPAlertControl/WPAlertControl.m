#import "WPAlertControl.h"

#define WPRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]
#define WPFont28 [UIFont systemFontOfSize:14]
#define iphoneXPadding 20
#define groupNormalHeight 6.0
#define kDevice_Is_control_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface WPAlertControl () <UITableViewDataSource,UITableViewDelegate>;
/** 是否已经显示 */
@property (nonatomic,assign) BOOL isShow;
/** 蒙板按钮 */
@property (nonatomic,weak) UIButton *mask;
/** 动画视图 */
@property (nonatomic,weak) UIView *animateView;
/** 动画类型 */
@property (nonatomic,assign) WPAlertBeginType beginType;
/** 结束动画类型 */
@property (nonatomic,assign) WPAlertEndType endType;
/** 结束开始点 */
@property (nonatomic,assign) CGPoint beginPoint;
/** 动画结束开始点 */
@property (nonatomic,assign) CGPoint endPoint;
/** 常量 -1 == 居中*/
@property (nonatomic,assign) CGFloat constant;
/** 结束动画以后的frame */
@property (nonatomic,assign) CGRect endFrame;
/** 结束动画以后的不动的frame */
@property (nonatomic,assign) CGRect endConstantFrame;
/** 显示弹框的状态block */
@property (nonatomic,copy) AlertAnimateStatus animateStatus;
/** 弹框隐藏的时候调用 */
@property (nonatomic,copy) AlertAnimateStatus complete;
/** 蒙板点击调用 */
@property (nonatomic,copy) MaskClickBlock maskClick;
/** 动画类型 */
@property (nonatomic,assign) WPAlertAnimateType animateType;
/** push结束动画 中间变量*/
@property (nonatomic,assign) WPAlertEndType pushEndType;
/** item模式数组 */
@property (nonatomic,strong) NSArray <WPAlertGroup *>*items;
/** item模式数组 */
@property (nonatomic,strong) NSArray <WPAlertGroup *>*pushItems;
/** item点击掉用 */
@property (nonatomic,copy) ItemClick itemBlock;
/** 菜单等级 */
@property (nonatomic,assign) NSUInteger alertLevel;
/** 蒙版开始显示时的颜色 */
@property (nonatomic,strong) UIColor *maskBeginColor;
/** 蒙版显示完以后的颜色 */
@property (nonatomic,strong) UIColor *maskEndColor;
/** 是否需要设置形变 */
@property (nonatomic,assign) BOOL isTransform;
/** 是否需要拖拽手势 */
@property (nonatomic,assign) BOOL isPan;
/** 动画开始持续的时间 */
@property (nonatomic,assign) CGFloat animageBeginInterval;
/** 动画结束持续时间 */
@property (nonatomic,assign) CGFloat animageEndInterval;
/** 下个动画视图 */
@property (nonatomic,strong) UIView *pushAnimateView;
@end

@implementation WPAlertControl (WPExtension)
+ (instancetype)alertItemsForRootControl:(UIViewController *)rootControl animateType:(WPAlertAnimateType)animateType items:(NSArray *)items index:(ItemClick)index
{
    if (!rootControl) {
        rootControl = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    NSMutableArray *groups = [NSMutableArray array];
    if (items.count) {
        NSObject *obj = items.lastObject;
        if ([obj isKindOfClass:[NSString class]]) {
            NSMutableArray *itemsG = [NSMutableArray array];
            
            for (NSString *string in items) {
                [itemsG addObject:[WPAlertItem item:string]];
            }
            
            WPAlertGroup *g0 = [WPAlertGroup group:itemsG];
            [groups addObject:g0];
            
        }else if ([obj isKindOfClass:[NSArray class]]){
            
            for (NSArray *array in items) {
                NSMutableArray *itemsG = [NSMutableArray array];
                for (NSString *string in array) {
                    [itemsG addObject:[WPAlertItem item:string]];
                }
                [groups addObject:[WPAlertGroup group:itemsG]];
            }
        }
    }
    
    return [self alertForItems:groups index:index begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:animateType constant:0 animageBeginInterval:alertTimeBeginInterval animageEndInterval:alertTimeEndInterval maskColor:nil pan:YES rootControl:rootControl maskClick:nil animateStatus:nil];
}
@end

@implementation WPAlertControl

+ (instancetype)alertForView:(UIView *)inputView begin:(WPAlertBeginType)type end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType constant:(CGFloat)constant animageBeginInterval:(CGFloat)beginInterval animageEndInterval:(CGFloat)endInterval maskColor:(UIColor *)maskColor pan:(BOOL)pan rootControl:(UIViewController *)rootControl maskClick:(MaskClickBlock)click animateStatus:(AlertAnimateStatus)animateStatus
{
    WPAlertControl *controller = [WPAlertControl new];
    controller.animageBeginInterval = beginInterval;
    controller.animageEndInterval = endInterval;
    controller.maskEndColor = maskColor;
    controller.isPan = pan;
    controller.beginType = type;
    controller.endType = endType;
    controller.constant = constant;
    controller.maskClick = click;
    controller.animateStatus = animateStatus;
    controller.animateView = inputView;
    controller.animateType = animateType;
    controller.view.frame = rootControl.view.bounds;
    [rootControl presentViewController:controller animated:NO completion:nil];
    return controller;
}

+ (instancetype)alertForItems:(NSArray <WPAlertGroup *>*)items index:(ItemClick)index begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType constant:(CGFloat)constant animageBeginInterval:(CGFloat)beginInterval animageEndInterval:(CGFloat)endInterval maskColor:(UIColor *)maskColor pan:(BOOL)pan rootControl:(UIViewController *)rootControl maskClick:(MaskClickBlock)click animateStatus:(AlertAnimateStatus)animateStatus
{
    WPAlertControl *control = [WPAlertControl new];
    control.animageBeginInterval = beginInterval;
    control.animageEndInterval = endInterval;
    control.maskEndColor = maskColor;
    control.isPan = pan;
    control.beginType = beginType;
    control.endType = endType;
    control.items = items;
    control.itemBlock = index;
    control.animateStatus = animateStatus;
    control.maskClick = click;
    control.constant = constant;
    control.animateType = animateType;
    control.view.frame = rootControl.view.bounds;
    [rootControl presentViewController:control animated:NO completion:nil];
    return control;
}

+ (void)alertHiddenForRootControl:(UIViewController *)control completion:(AlertAnimateStatus)completion
{
    UIViewController *aerltControl =  control.presentedViewController;
    
    if ([aerltControl.class isSubclassOfClass:[WPAlertControl class]] ) {
        WPAlertControl *alert = (WPAlertControl *)aerltControl;
        alert.pushAnimateView = nil;
        alert.pushItems = nil;
        alert.complete = completion;
        [alert animateForShow:NO];
    }
}

+ (instancetype)currentAlertControFor:(UIViewController *)rootControl
{
    return (WPAlertControl *)rootControl.presentedViewController;
}

#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.items[indexPath.section].items[indexPath.row].style == UITableViewCellSelectionStyleNone)return;
    
    NSInteger index = 0;
    
    if (indexPath.section) {
        for (int i = 0; i<indexPath.section; i++) {
            WPAlertGroup *group = self.items[i];
            index = group.items.count+index;
        }
        index = index+indexPath.row;
    }else{
        index = indexPath.row;
    }

    if (self.itemBlock) {
        self.pushItems = self.itemBlock(index,self.alertLevel,self);
        
        [self endAnimate];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items[section].items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"WPAlertControlCell";
    WPAlertControlCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (!cell) {
        cell = [[WPAlertControlCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.item = self.items[indexPath.section].items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.items[section].groupHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.items[section].groupView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.section].items[indexPath.row].cellHeight;
}

#pragma mark 核心代码
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 开始动画
    [self animateForShow:YES];
}

- (instancetype)init
{
    if ([super init]) {
        /** 设置成透明色 */
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        self.view.clipsToBounds = YES;
        UIButton *mask = [UIButton new];
        [mask addTarget:self action:@selector(maskTouch:) forControlEvents:UIControlEventTouchUpInside];
        _mask = mask;
        [self.view addSubview:mask];
    }
    return self;
}

- (void)setEndType:(WPAlertEndType)endType
{
    _endType = endType;
    self.pushEndType = endType;
}

- (UIColor *)maskBeginColor
{
    if (!_maskBeginColor) {
        _maskBeginColor = [UIColor clearColor];
    }
    return _maskBeginColor;
}

- (UIColor *)maskEndColor
{
    if (!_maskEndColor) {
        _maskEndColor = alertDefaultMaskColor;
    }
    return _maskEndColor;
}

- (CGFloat)animageBeginInterval
{
    if (_animageBeginInterval > 0) {
        return _animageBeginInterval;
    }else{
        return 0;
    }
}

- (CGFloat)animageEndInterval{
    if (_animageEndInterval > 0) {
        return _animageEndInterval;
    }else{
        return 0;
    }
}

/** 蒙版点击 */
- (void)maskTouch:(UIButton *)mask
{
    self.pushAnimateView = nil;
    self.pushItems = nil;
    
    if (self.maskClick) {
        
        BOOL isMask = self.maskClick(-1,self.alertLevel ,self);
        if (isMask) {
            if(self.isShow) return;
            [self beginAnimateIsImplementBlock:YES];
        }else{
            [self endAnimate];
        }
    }else{
        
        [self endAnimate];
    }
}

- (void)beginAnimateIsImplementBlock:(BOOL)isImplement
{
    self.alertLevel++;
    
    if (self.animateType == WPAlertAnimateDefault) {
        [self animateDefaultBeginIsImplementBlock:isImplement];
        
    }else if (self.animateType == WPAlertAnimateBounce){
        [self animateBounceBeginIsImplementBlock:isImplement];
    }
}

- (void)endAnimate
{
    if (self.animateType == WPAlertAnimateDefault) {
        [self animateDefaultEnd];
        
    }else if(self.animateType == WPAlertAnimateBounce){
        [self animateBounceEnd];
    }
}

/** 开始动画 */
- (void)animateForShow:(BOOL)show
{
    if (show) {
        
        // 已经显示就返回
        if (self.isShow) return;
        
        if (self.animateStatus) {
            self.animateStatus(WPAnimateWillAppear,self);
        }
        
        if (!self.isShow) {
            self.mask.userInteractionEnabled = NO;
            [self beginAnimateIsImplementBlock:YES];
        }
    }else{
        // 设置显示状态
        if (self.animateStatus) {
            self.animateStatus(WPAnimateWillDisappear,self);
        }
        
        // 即将结束调用
        if (self.complete) {
            self.complete(WPAnimateWillDisappear,self);
        }
        
        self.mask.userInteractionEnabled = YES;
        
        [self endAnimate];
    }
}

/** 默认开始动画 */
- (void)animateDefaultBeginIsImplementBlock:(BOOL)isImplement
{
    
    [UIView animateWithDuration:self.animageBeginInterval animations:^{
        if (self.beginType == WPAlertEndCenter) {
            self.animateView.transform = CGAffineTransformIdentity;
            self.animateView.alpha = 1;
        }else{
//            self.animateView.origin = self.beginPoint;
            self.animateView.frame = CGRectMake(self.beginPoint.x, self.beginPoint.y, self.animateView.frame.size.width, self.animateView.frame.size.height);
        }
        self.mask.backgroundColor = self.maskEndColor;
    } completion:^(BOOL finished) {
        self.endFrame = self.animateView.frame;
        self.endConstantFrame = self.animateView.frame;
        self.isShow = YES;
        self.mask.userInteractionEnabled = YES;
        if (self.animateStatus && self.isShow) {
            if (isImplement) {
                self.animateStatus(WPAnimateDidAppear,self);
            }
        }
        self.pushAnimateView = nil;
    }];
}

/** 默认结束动画 */
- (void)animateDefaultEnd
{
    [self animateBounceEnd];
}

/** 弹跳开始动画 */
- (void)animateBounceBeginIsImplementBlock:(BOOL)isImplement
{
    if (self.isTransform) {
        self.animateView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    }else{
        
    }
    
    [UIView animateWithDuration:self.animageBeginInterval delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        if (self.beginType == WPAlertEndCenter) {
            self.animateView.transform = CGAffineTransformIdentity;
            self.animateView.alpha = 1;
        }else{
//            self.animateView.origin = self.beginPoint;
            self.animateView.frame = CGRectMake(self.beginPoint.x, self.beginPoint.y, self.animateView.frame.size.width, self.animateView.frame.size.height);
        }
        self.mask.backgroundColor = self.maskEndColor;
        
    } completion:^(BOOL finished) {
        self.endFrame = self.animateView.frame;
        self.endConstantFrame = self.animateView.frame;
        self.isShow = YES;
        self.mask.userInteractionEnabled = YES;
        if (self.animateStatus && self.isShow) {
            if (isImplement) {
                self.animateStatus(WPAnimateDidAppear,self);
            }
        }
        self.pushAnimateView = nil;
    }];
}

/** 弹跳结束动画 */
- (void)animateBounceEnd
{
    [UIView animateWithDuration:self.animageEndInterval animations:^{
        if (self.endType == WPAlertEndCenter) {
            self.animateView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            self.animateView.alpha = 0;
        }else{
            self.animateView.frame = CGRectMake(self.endPoint.x, self.endPoint.y, self.animateView.frame.size.width, self.animateView.frame.size.height);
        }
        
        if (!self.pushAnimateView && !self.pushItems.count) { // 当push动画视图没有的时候才改变颜色
            self.mask.backgroundColor = self.maskBeginColor;
        }
    } completion:^(BOOL finished) {
        self.mask.userInteractionEnabled = NO;
        [self.animateView removeFromSuperview];
        self.endType = self.pushEndType;
        if (self.pushAnimateView) {
            self.animateView = self.pushAnimateView;
            
            // 选择动画类型 重新开启动画
            [self beginAnimateIsImplementBlock:YES];
            
        }else if (self.pushItems.count){
            
            self.items = self.pushItems;
            
            // 选择动画类型 重新开启动画
            [self beginAnimateIsImplementBlock:YES];
            
        }else{
            
            if (self.animateStatus) {
                self.animateStatus(WPAnimateDidDisappear,self);
            }
            
            if (self.complete) {
                self.complete(WPAnimateDidDisappear,self);
            }
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void)setPushView:(UIView *)pushView
{
    self.pushAnimateView = pushView;
}

- (void)setPushView:(UIView *)pushView begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType
{
    self.beginType = beginType;
    self.pushEndType = endType;
    self.animateType = animateType;
    self.pushAnimateView = pushView;
}

- (void)setPushView:(UIView *)pushView begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType pan:(BOOL)pan constant:(CGFloat)constant
{
    self.constant = constant;
    self.isPan = pan;
    [self setPushView:pushView begin:beginType end:endType animateType:animateType];
}

- (void)setPushView:(UIView *)pushView begin:(WPAlertBeginType)beginType end:(WPAlertEndType)endType animateType:(WPAlertAnimateType)animateType pan:(BOOL)pan constant:(CGFloat)constant animageBeginInterval:(CGFloat)beginInterval animageEndInterval:(CGFloat)endInterval
{
    self.animageBeginInterval = beginInterval;
    self.animageEndInterval = endInterval;
    [self setPushView:pushView begin:beginType end:endType animateType:animateType pan:pan constant:constant];
}

- (void)setAnimateView:(UIView *)animateView
{
    _animateView = animateView;
    
    [self.view addSubview:animateView];
    
    CGFloat w = animateView.frame.size.width;
    CGFloat h = animateView.frame.size.height;
    
    CGFloat maxW = [UIApplication sharedApplication].windows.lastObject.frame.size.width;
    CGFloat maxH =  [UIApplication sharedApplication].windows.lastObject.frame.size.height;
    CGFloat constant = self.constant;
    
    if (constant == -1) {
        if (self.beginType == WPAlertBeginLeft || self.beginType == WPAlertBeginRight) {
            if (self.beginType == WPAlertBeginLeft) {
                constant = (maxW-w) * 0.5;
            }else{
                constant = - (maxW-w) * 0.5;
            }
        }else if (self.beginType == WPAlertBeginTop || self.beginType == WPAlertBeginBottem){
            if (self.beginType == WPAlertBeginTop) {
                constant = (maxH -h) * 0.5;
            }else{
                constant = - (maxH -h) * 0.5;
            }
        }
    }
    
    // 开始动画计算
    if (self.beginType == WPAlertBeginLeft) { // 左边动画
        animateView.frame = CGRectMake(-animateView.frame.size.width, (maxH-h) * 0.5, animateView.frame.size.width, animateView.frame.size.height);
        self.beginPoint = CGPointMake(0+constant, animateView.frame.origin.y);
        
    } else if (self.beginType == WPAlertBeginRight){ // 右边动画
        animateView.frame = CGRectMake(maxW, (maxH-h)*0.5, animateView.frame.size.width, animateView.frame.size.height);
        self.beginPoint = CGPointMake(maxW-w+constant, animateView.frame.origin.y);
        
    } else if (self.beginType == WPAlertBeginTop){ // 上动画
        animateView.frame = CGRectMake((maxW-w)*0.5, -h, animateView.frame.size.width, animateView.frame.size.height);
        self.beginPoint = CGPointMake(animateView.frame.origin.x, 0+constant);
        
    } else if (self.beginType == WPAlertBeginBottem){ // 底部动画
        animateView.frame = CGRectMake((maxW-w) * 0.5, maxH, animateView.frame.size.width, animateView.frame.size.height);
        self.beginPoint = CGPointMake(animateView.frame.origin.x,maxH-h+constant);
        
    } else if (self.beginType == WPAlertBeginCenter){ // 中心动画
        self.beginPoint = CGPointMake((maxW-animateView.frame.size.width) * 0.5, (maxH-animateView.frame.size.height) * 0.5);
        animateView.frame = CGRectMake(self.beginPoint.x, self.beginPoint.y, animateView.frame.size.width, animateView.frame.size.height);
        animateView.alpha = 0;
        animateView.layer.masksToBounds = NO;
        animateView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
        animateView.layer.shadowRadius = 20;
        animateView.layer.shadowOpacity = 1;
        animateView.layer.shadowOffset = CGSizeMake(0, 10);
        self.isTransform = YES;
    }
    
    // 结束动画计算
    if (self.endType == WPAlertEndLeft) {
        self.endPoint = CGPointMake(-h, self.beginPoint.y);
    } else if (self.endType == WPAlertEndRight){
        self.endPoint = CGPointMake(maxW, self.beginPoint.y);
    } else if (self.endType == WPAlertEndTop){
        self.endPoint = CGPointMake(self.beginPoint.x, -h);
    } else if (self.endType == WPAlertEndBottem){
        self.endPoint = CGPointMake(self.beginPoint.x, maxH);
    }else if (self.endType == WPAlertEndCenter){
        self.endPoint = self.view.center;
    }
    
    if (self.isPan) {
        // 添加手势
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
        [animateView addGestureRecognizer:panGR];
        
    }
}

- (void)setItems:(NSArray<WPAlertGroup *> *)items
{
    _items = items;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [UIView new];
    tableView.showsVerticalScrollIndicator = NO;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    footView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = footView;
    
    for (WPAlertGroup *group in items) {

        if(group.groupHeight == groupNormalHeight){
            if(group.groupView.text.length){
                group.groupHeight = 20.0;
            }
        }
    }

    if(items.firstObject.groupView.text.length){
        items.firstObject.groupHeight = 20;
    }else if(items.firstObject.groupHeight == groupNormalHeight){
        items.firstObject.groupHeight = 0;
    }
    
    // 计算高度
    CGFloat h = 0;
    for (int a = 0; a<items.count; a++) {
        WPAlertGroup *group = items[a];
        for (int i = 0; i<group.items.count; i++) {
            h = h + group.items[i].cellHeight;
        }
            h = h+group.groupHeight;
    }

    // 适配X
    if (kDevice_Is_control_iPhoneX) {
        tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, h+iphoneXPadding);
        
    }else{
        tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, h);
    }
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    
    
    self.animateView = tableView;
}

- (void)setPushItems:(NSArray<WPAlertGroup *> *)items pushItemsClick:(ItemClick)click
{
    self.beginType = WPAlertBeginBottem;
    self.pushEndType = WPAlertEndBottem;
    self.isPan = NO;
    self.pushItems = items;
    self.itemBlock = click;
}

- (void)setPushItems:(NSArray<WPAlertGroup *> *)pushItems
{
    NSMutableArray *groups = [NSMutableArray array];
    NSObject *obj = pushItems.lastObject;
    if ([obj isKindOfClass:[NSString class]]) {
        NSMutableArray *itemsG = [NSMutableArray array];
        
        for (NSString *string in pushItems) {
            [itemsG addObject:[WPAlertItem item:string]];
        }
        
        WPAlertGroup *g0 = [WPAlertGroup group:itemsG];
        [groups addObject:g0];
        
    }else if ([obj isKindOfClass:[NSArray class]]){
        
        for (NSArray *array in pushItems) {
            NSMutableArray *itemsG = [NSMutableArray array];
            for (NSString *string in array) {
                [itemsG addObject:[WPAlertItem item:string]];
            }
            [groups addObject:[WPAlertGroup group:itemsG]];
        }
    }else{
        groups = [NSMutableArray arrayWithArray:pushItems];
    }
    
    BOOL isEqual = NO;
    
    // 检测是否是相同的item
    if (groups.count == self.items.count) {
        
        for (int i = 0; i<groups.count; i++) {
            WPAlertGroup *g0 = groups[i];
            WPAlertGroup *g1 = self.items[i];
            
            if (g1.items.count == g0.items.count) {
                
                for (int a = 0; a<g0.items.count; a++) {
                    WPAlertItem *i0 = g0.items[a];
                    WPAlertItem *i1 = g1.items[a];
                    
                    if ([i0.title isEqualToString:i1.title]) {
                        isEqual = YES;
                    }else{
                        isEqual = NO;
                        break;
                    }
                }                
            }else{
                isEqual = NO;
            }
        }
    }
    
    if (isEqual) {
        _pushItems = nil;
    }else{
        _pushItems = groups;
    }
}

- (void)panGRAct:(UIPanGestureRecognizer *)recongnizer
{
    // 获取触摸对象
    CGPoint point = [recongnizer translationInView:self.view];
    
    if (self.endType == WPAlertEndLeft && self.beginType == WPAlertBeginLeft) { // 开始动画
        if (point.x>=0) return;
        // 调整位置
        self.animateView.frame = CGRectMake(self.endFrame.origin.x + point.x, self.endFrame.origin.y, self.animateView.frame.size.width, self.animateView.frame.size.height);
        
    }else if (self.endType == WPAlertEndRight && self.beginType == WPAlertBeginRight){
        if (point.x<=0) return;
        // 调整位置
        self.animateView.frame = CGRectMake(self.endFrame.origin.x + point.x,self.endFrame.origin.y , self.animateView.frame.size.width, self.animateView.frame.size.height);
    }else if (self.endType == WPAlertEndTop && self.beginType == WPAlertBeginTop){ // 从上面弹出来的时候
        if (point.y>=0) return;
        self.animateView.frame = CGRectMake(self.endConstantFrame.origin.x, self.endFrame.origin.y+point.y, self.endConstantFrame.size.width, self.endConstantFrame.size.height);
    }else if (self.endType == WPAlertEndBottem && self.beginType == WPAlertBeginBottem){
        if (point.y<=0) return;
        self.animateView.frame = CGRectMake(self.endConstantFrame.origin.x, self.endFrame.origin.y+point.y, self.endConstantFrame.size.width, self.endConstantFrame.size.height);
    }
    
    // 结束拖动以后
    if(recongnizer.state == UIGestureRecognizerStateEnded || recongnizer.state == UIGestureRecognizerStateCancelled){
        self.endFrame = self.animateView.frame;
        CGFloat pad = 0.5;
        CGFloat moveX = 0; // 移动的量
        CGFloat moveY = 0; // 移动的量
        
        if (self.endType == WPAlertEndLeft && self.beginType == WPAlertBeginLeft) { // 左边的动画
            moveX = self.endConstantFrame.origin.x - self.endFrame.origin.x;
            
            // 判断当前在哪个点上
            if (moveX < self.endConstantFrame.size.width * pad) { // 复位
                [self beginAnimateIsImplementBlock:NO];
            }else{ // 结束弹框
                [self endAnimate];
            }
            
        }else if (self.endType == WPAlertEndRight && self.beginType == WPAlertBeginRight){ // 右边动画
            moveX = point.x;
            
            // 判断当前在哪个点上
            if (moveX < self.endConstantFrame.size.width * pad) { // 复位
                [self beginAnimateIsImplementBlock:NO];
            }else{ // 结束弹框
                
                [self endAnimate];
            }
        }else if (self.endType == WPAlertEndTop && self.beginType == WPAlertBeginTop){
            moveY = CGRectGetMaxY(self.endConstantFrame) + point.y;
            
            // 判断当前在哪个点上
            if (moveY > CGRectGetMaxY(self.endConstantFrame) * pad) { // 复位
                [self beginAnimateIsImplementBlock:NO];
            }else{ // 结束弹框
                [self endAnimate];
            }
        }else if (self.endType == WPAlertEndBottem && self.beginType == WPAlertEndBottem){
            moveY = point.y;
            
            if (moveY < self.endConstantFrame.size.height * pad) {
                [self beginAnimateIsImplementBlock:NO];
            }else{
                [self endAnimate];
            }
        }
        
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mask.frame = self.view.frame;
}

@end

@implementation WPAlertGroup
+ (instancetype)group:(NSArray<WPAlertItem *> *)items
{
    WPAlertGroup *group = [self new];
    group.items = items;
    return group;
}

+ (instancetype)groupForTitle:(NSString *)title items:(NSArray<WPAlertItem *> *)items
{
    WPAlertGroup *group = [self group:items];
    group.groupView.text = title;
    return group;
}

-(instancetype)init
{
    if ([super init]) {
        UILabel *view = [UILabel new];
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont systemFontOfSize:14];
        view.backgroundColor = WPRGB(238,238,238);
        self.groupView = view;
        self.groupHeight = groupNormalHeight;
    }
    return self;
}

@end

@implementation WPAlertItem
+ (instancetype)item:(NSString *)title
{
    WPAlertItem *item = [self new];
    item.title = title;
    return item;
}

+ (instancetype)itemSettingCell:(setttingControlCell)cellBlock
{
    WPAlertItem *item = [self new];
    item.settingCell = cellBlock;
    return item;
}

- (instancetype)init
{
    if ([super init]) {
        self.cellHeight = 44.0;
    }
    return self;
}

@end

@implementation WPAlertControlCell

- (void)setItem:(WPAlertItem *)item
{
    _item = item;
    
    self.textLabel.text = item.title;
    !item.settingCell ?: item.settingCell(self);
    item.style = self.selectionStyle;
    if(self.textLabel.text.length){
        item.title = self.textLabel.text;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.textLabel.frame = CGRectMake((self.frame.size.width - self.textLabel.frame.size.width) * 0.5, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake((self.frame.size.width - self.detailTextLabel.frame.size.width) * 0.5, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}
@end





