# WPAlertControl
上下左右中心，多层级全方位弹框
Upper and lower center, multi-level all-round cartridge, easy to create,
support multi-level push one line code creation to solve the project% 80 cartridge requirements

* animateView 动画视图 animateView的size必须有值
* begin 视图开始弹出的类型
* endType 动画结束弹出的类型
* constant 常量 默认0 -1==居中 动画结束时候的frame+上常量 可以微调动画结束后的frame
* beginInterval 视图弹出的持续时间
* endInterval 视图结束弹出的时间
* masColor 蒙版的颜色
* pan 是否支持拖动隐藏
* rootControl alert弹出试图的根控制器
* masClick 蒙版点击执行 return NO 蒙版不会消失 YES蒙版消失 默认YES
* animateStatus alert弹框的当前状态 即将显示 -> 显示完成 -> 即将消失 -> 消失完成
* alertLevel 当前动画的等级 默认为1 设置了pushAnimateView后会累加
* items 菜单内容
* index item 点击的索引
* animateType 动画类型
