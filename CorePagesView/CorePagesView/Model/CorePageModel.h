//
//  CorePageModel.h
//  CorePageModel
//
//  Created by 冯成林 on 15/3/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//  描述顶部item的模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CorePageModel : NSObject


/**
 *  控制器
 */
@property (nonatomic,strong) UIViewController *pageVC;


/**
 *  控制器对应的名称
 */
@property (nonatomic,copy) NSString *pageBarName;



/**
 *  每一个item的bar实际占用的宽度
 */
@property (nonatomic,assign) CGFloat padding;





/**
 *  快速创建一个page模型
 *
 *  @param pageVC       控制器
 *  @param pageBarName  控制器对应的名称
 *
 *  @return 实例
 */
+(instancetype)model:(UIViewController *)pageVC pageBarName:(NSString *)pageBarName;




/**
 *  模型检查
 */
+(BOOL)modelCheck:(NSArray *)pageModels;








@end
