//
//  CoreTabsView.h
//  CoreTabsVC
//
//  Created by 冯成林 on 15/3/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePageModel.h"
#import "CorePagesViewConfig.h"


@interface CorePagesView : UIView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


/** 中转到指定页码 */
-(void)jumpToPage:(NSUInteger)jumpPage;



/**
 *  快速实例化对象
 *
 *  @param ownerVC    本视图所属的控制器
 *  @param pageModels 模型数组
 *  @param config     配置
 *
 *  @return 实例
 */
+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels config:(CorePagesViewConfig *)config;






@end
