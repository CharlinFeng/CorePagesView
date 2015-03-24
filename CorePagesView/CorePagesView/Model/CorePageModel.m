//
//  TabsBarModel.m
//  CoreTabsVC
//
//  Created by 冯成林 on 15/3/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CorePageModel.h"


@interface CorePageModel ()



@end




@implementation CorePageModel



/**
 *  快速创建一个page模型
 *
 *  @param pageVC       控制器
 *  @param pageBarName  控制器对应的名称
 *
 *  @return 实例
 */
+(instancetype)model:(UIViewController *)pageVC pageBarName:(NSString *)pageBarName{
    
    CorePageModel *pageModel=[[CorePageModel alloc] init];
    
    pageModel.pageVC=pageVC;
    pageModel.pageBarName=pageBarName;
    
    return pageModel;
}




/**
 *  模型检查
 */
+(BOOL)modelCheck:(NSArray *)pageModels{
    
    if(pageModels==nil || pageModels.count==0) return NO;
    
    for (id obj in pageModels) {
        if([obj isKindOfClass:[self class]]) continue;
        return NO;
    }
    
    return YES;
}



@end
