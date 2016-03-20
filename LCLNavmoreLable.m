//
//  LCLNavmoreLable.m
//  navmorelible
//
//  Created by 覗文君 on 15-9-1.
//  Copyright (c) 2015年 覗文君. All rights reserved.
//  横向滚动简单的封装分页
//
// 时间:2015-09-01 16:12:19
// BUG 如果view的地址相同只能有一个有效(待解决...)
// BUG 只能显示3+页面 下个版本修改

//#define DefinePage 5
#import "LCLNavmoreLable.h"

@interface LCLNavmoreLable (){
    CGFloat Screen_height;
    CGFloat Screen_width;
    NSInteger DefinePage;
}

@end

@implementation LCLNavmoreLable
@synthesize titleColor;
@synthesize lineColor;
@synthesize titleBGColor;
@synthesize ScrollView;
+ (LCLNavmoreLable*)initWithFrame:(CGRect )frame NavmoreLableWithTitle:(NSArray*)Titlearray view:(NSArray*)viewarray {
    LCLNavmoreLable *Mainview = [[LCLNavmoreLable alloc]initWithFrame:frame Title:Titlearray view:viewarray];
    return Mainview;
}

- (instancetype)initWithFrame:(CGRect)frame Title:(NSArray*)Titlearray view:(NSArray*)viewarray{
    if (self = [super initWithFrame:frame]) {
        Screen_height = frame.size.height;
        Screen_width = frame.size.width;
        DefinePage = viewarray.count;
        self.backgroundColor = [UIColor clearColor];
        if (Titlearray.count == viewarray.count) {
            pageall = viewarray.count;
            navheight = 64;//Nav高度
            navLibleh = 25;//文字高度
            navh = navLibleh + navheight;//总高度
            [self setTitleView:Titlearray];
            [self setScrollViewcontent:viewarray];
            NSLog(@"navLibleh = %f",navLibleh);
        }else if(Titlearray.count != viewarray.count&&Titlearray==nil){
            navheight = 64;//Nav高度
            navLibleh = 0;//文字高度
            navh = navLibleh;//总高度
            pageall = viewarray.count;
            [self setScrollViewcontent:viewarray];
        }
    }
    return self;
}

- (void)setScrollViewcontent:(NSArray*)viewarray{
    ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navLibleh, Screen_width, Screen_height-navLibleh)];
    [ScrollView setContentSize:CGSizeMake(Screen_width*viewarray.count, Screen_height-navLibleh)];
    ScrollView.pagingEnabled = YES;
    ScrollView.showsHorizontalScrollIndicator = NO;
    ScrollView.showsVerticalScrollIndicator = NO;
    ScrollView.bounces = NO;
    ScrollView.delegate = self;
    
    for (int i = 0; i < viewarray.count; i++) {
        [[viewarray objectAtIndex:i] setFrame:CGRectMake(i*Screen_width, 0, Screen_width, Screen_height-navh)];
        [ScrollView addSubview:[viewarray objectAtIndex:i]];
        //[ScrollView addSubview:view];
        NSLog(@"%@",[viewarray objectAtIndex:i]);
    }
    [self addSubview:ScrollView];
}

- (void)setTitleView:(NSArray*)Titlearray{
    CGFloat LineW = pageall<DefinePage ?Screen_width:Screen_width/DefinePage*pageall;
    TitleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, navLibleh)];
    [TitleView setBackgroundColor:[UIColor blueColor]];
    TitleView.pagingEnabled = NO;
    TitleView.showsHorizontalScrollIndicator = NO;
    TitleView.showsVerticalScrollIndicator = NO;
    TitleView.bounces = YES;
    [TitleView setContentSize:CGSizeMake(LineW, navLibleh)];

    line  = [[UILabel alloc]initWithFrame:CGRectMake((Screen_width/DefinePage-40)/2, navLibleh-7, 40, 3)];
    
    
    //[line setBackgroundColor:lrcolor];
    [TitleView setBackgroundColor:KCOLOR(247, 247, 247)];
    [TitleView addSubview:line];
    
    for (int i = 0; i < Titlearray.count ; i++) {
        UIButton *titlebutton = [[UIButton   alloc]initWithFrame:CGRectMake(i*Screen_width/DefinePage, 0, Screen_width/DefinePage, navLibleh)];
        [titlebutton setTitle:Titlearray[i] forState:UIControlStateNormal];
        [titlebutton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [titlebutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        titlebutton.tag = i;
        titlebutton.titleLabel.font = [UIFont systemFontOfSize:16];
        [titlebutton addTarget:self action:@selector(touchbuttonsyncscrollview:) forControlEvents:UIControlEventTouchUpInside];
        [titlebutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [TitleView addSubview:titlebutton];
    }
    

    [self addSubview:TitleView];
}


- (void)touchbuttonsyncscrollview:(UIButton*)sender{
    [self touchesTopage:sender.tag];
}
- (void)touchesTopage:(int)index{
    [ScrollView  setContentOffset:CGPointMake(Screen_width * index, 0)animated:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = sender.frame.size.width;
    CGRect lineRect = line.frame;
    [self.delegateNavmoreLable scrollViewDoingScroll:sender page:sender.contentOffset.x];
    [line setFrame:CGRectMake(sender.contentOffset.x/DefinePage+(Screen_width/DefinePage-40)/2, lineRect.origin.y, lineRect.size.width, lineRect.size.height)];
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (pageint != page) {
        pageint = page;
        //NSLog(@"int = %d",page);
        //CGRect linetoview = [line convertRect:self.bounds toView:nil];
        CGRect NewlineRect = line.frame;
        //NSLog(@"page = %d frame = %f",page,linetoview.origin.x);
        if (NewlineRect.origin.x <= 0) {
            [TitleView setContentOffset:CGPointMake(page*Screen_width/DefinePage, 0)animated:YES];
        }else if (NewlineRect.origin.x >= Screen_width*(DefinePage-1)/DefinePage) {
            [TitleView setContentOffset:CGPointMake((page-(DefinePage-1))*Screen_width/DefinePage, 0)animated:YES];
        }
        [self.delegateNavmoreLable scrollViewDidScrollpage:page];
    }
}

@end
