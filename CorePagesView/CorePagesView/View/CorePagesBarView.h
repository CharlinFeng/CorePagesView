//
//  TabsBarView.h
//  CoreTabsVC
//
//  Created by 冯成林 on 15/3/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePagesBarBtn.h"
#import "CorePagesViewConfig.h"

@interface CorePagesBarView : UIScrollView



/**
 *  分页模型数组
 */
@property (nonatomic,strong) NSArray *pageModels;



/**
 *  页码
 */
@property (nonatomic,assign) NSUInteger page;




/**
 *  btn操作block
 */
@property (nonatomic,copy) void (^btnActionBlock)(CorePagesBarBtn *btn,NSUInteger selectedIndex);


@property (nonatomic,strong) CorePagesViewConfig *config;

@end
