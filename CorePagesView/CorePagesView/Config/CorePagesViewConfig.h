//
//  CorePagesViewConfig.h
//  CorePagesView
//
//  Created by 成林 on 15/6/27.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CorePagesViewConfig : NSObject


/** 顶部按钮的基本宽度 */
@property (nonatomic,assign) CGFloat barBtnWidth;

/** 顶部按钮的扩展宽度 */
@property (nonatomic,assign) CGFloat barBtnExtraWidth;

/** 是否使用自定义的宽度，如果不使用，则框架自行计算宽度 */
@property (nonatomic,assign) BOOL isBarBtnUseCustomWidth;

/** bar条的高度 */
@property (nonatomic,assign) CGFloat barViewH;

/** 字体大小 */
@property (nonatomic,assign) CGFloat barBtnFontPoint;

/** 顶部菜单最左和最右的间距 */
@property (nonatomic,assign) CGFloat barScrollMargin;

/** 菜单按钮之间的间距 */
@property (nonatomic,assign) CGFloat barBtnMargin;

/** 线条多余长度（单边） */
@property (nonatomic,assign) CGFloat mainViewMargin;

/** 主体内容区间距值 */
@property (nonatomic,assign) CGFloat barLineViewPadding;

/** 动画时长 */
@property (nonatomic,assign) CGFloat animDuration;


@end
