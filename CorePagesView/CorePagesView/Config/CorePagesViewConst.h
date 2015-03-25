//
//  CorePagesViewConst.h
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CorePagesViewConst : NSObject



/**
 *  动态值
 */

/**
 *  顶部按钮的基本宽度
 */
#define CorePagesBarBtnWidth 100



/**
 *  顶部按钮的扩展宽度
 */
#define CorePagesBarBtnExtraWidth 60



/**
 *  是否使用自定义的宽度，如果不使用，则框架自行计算宽度
 */
#define CorePagesBarBtnUseCustomWidth NO


/**
 *  bar条的高度
 */
UIKIT_EXTERN CGFloat const CorePagesBarViewH;



/**
 *  字体大小
 */
UIKIT_EXTERN CGFloat const CorePagesBarBtnFontPoint;



/**
 *  顶部菜单最左和最右的间距
 */
UIKIT_EXTERN CGFloat const CorePagesBarScrollMargin;




/**
 *  菜单按钮之间的间距
 */
UIKIT_EXTERN CGFloat const CorePagesBarBtnMargin;



/**
 *  线条多余长度（单边）
 */
UIKIT_EXTERN CGFloat const CorePagesBarLineViewPadding;



/**
 *  主体内容区间距值
 */
UIKIT_EXTERN CGFloat const CorePagesMainViewMargin;




/**
 *  动画时长
 */
UIKIT_EXTERN CGFloat const CorePagesAnimDuration;


@end
