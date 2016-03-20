//
//  LCLNavmoreLable.h
//  navmorelible
//
//  Created by 覗文君 on 15-9-1.
//  Copyright (c) 2015年 覗文君. All rights reserved.
//  横向滚动简单的封装分页
//
// 时间:2015-09-01 16:12:19
// BUG 如果view的地址相同只能有一个有效(待解决...)
// BUG 只能显示3+页面 下个版本修改
// 时间:2016-01-31 19:06:27
// 修复BUG 解决动画闪动
// 修复BUG 适配iPad
#import <UIKit/UIKit.h>

@protocol LCLnavmoreLableDelegate <NSObject>
//当前页面
- (void)scrollViewDidScrollpage:(int)ipage;

@optional
//距离
- (void)scrollViewDoingScroll:(UIScrollView *)Scroll page:(float)x;
@end

@interface LCLNavmoreLable : UIView<UIScrollViewDelegate>{
    CGFloat navLibleh;
    CGFloat navheight;
    CGFloat navh;
    int pageall;//一共页面
    int pageint;//当前页面
    UILabel *line;//线条
    UIScrollView *ScrollView;//滚动部分
    UIScrollView *TitleView;//顶部部分
}

+ (LCLNavmoreLable*)initWithFrame:(CGRect )frame NavmoreLableWithTitle:(NSArray*)Titlearray view:(NSArray*)viewarray;
- (void)touchesTopage:(int) index;//跳自index页
@property (weak, nonatomic) id <LCLnavmoreLableDelegate> delegateNavmoreLable;
@property (strong, nonatomic) UIScrollView *ScrollView;//滚动部分
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *titleBGColor;
@end
