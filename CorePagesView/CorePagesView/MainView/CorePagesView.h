//
//  CoreTabsView.h
//  CoreTabsVC
//
//  Created by 冯成林 on 15/3/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePageModel.h"


@interface CorePagesView : UIView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;







/*
 *  快速实例化对象
 */
+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels;






@end
