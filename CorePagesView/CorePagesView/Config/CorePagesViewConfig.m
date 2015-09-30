//
//  CorePagesViewConfig.m
//  CorePagesView
//
//  Created by 成林 on 15/6/27.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CorePagesViewConfig.h"

@implementation CorePagesViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //默认值设置
        [self defaultValueSet];
    }
    return self;
}


/** 默认值设置 */
-(void)defaultValueSet{
    
    //顶部按钮的基本宽度
    _barBtnWidth = 60;
    
    //顶部按钮的扩展宽度
    _barBtnExtraWidth = 0;
    
    //是否使用自定义的宽度，如果不使用，则框架自行计算宽度
    _isBarBtnUseCustomWidth = YES;
    
    //bar条的高度
    _barViewH = 44;
    
    //字体大小
    _barBtnFontPoint = 15.0f;
    
    //顶部菜单最左和最右的间距
    _barScrollMargin = 0;
    
    //菜单按钮之间的间距
    _barBtnMargin = 0;
    
    //线条多余长度（单边）
    _barLineViewPadding = 0;
    
    //主体内容区间距值
    _mainViewMargin = 0;
    
    //动画时长
    _animDuration = 0.25f;
}


@end
