//
//  CoreListController.h
//  CoreListMVC
//
//  Created by 沐汐 on 15-3-11.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//  TableView列表控制器和CollectionView列表控制器的父类
//
//  目的：统一上拉下拉业务，高度封装。
//
//  1.无缓存功能
//  2.含上拉下拉功能。
//  3.上拉下拉可定制，即可选择是否添加上拉功能、下拉功能。
//  4.支持自动数据转模型操作。
//  5.支持GET/POST请求。



#import <UIKit/UIKit.h>
#import "LTConfigModel.h"
#import "CoreHttp.h"

@interface CoreListVC : UIViewController

/**
 *  配置模型
 */
@property (nonatomic,strong) LTConfigModel *configModel;


/**
 *  数据
 */
@property (nonatomic,strong) NSArray *dataList;



/**
 *  scrollView
 */
@property (nonatomic,strong) UIScrollView *scrollView;


@property (nonatomic,copy) void (^errorBlock)(CoreHttpErrorType errorType);



/**
 *  模型配置正确。框架开始运作。
 */
-(void)workBegin;


/**
 *  重新加载数据(内部子类调用,此方法不会导致请求网络数据)
 */
-(void)reloadData;



/**
 *  刷新获取最新数据：此方法会触发顶部刷新控件，并且scrollView会回到顶部
 */
-(void)reloadDataWithheaderViewStateRefresh;


/**
 *  刷新获取最新数据：此方法不会触发顶部刷新控件，scrollView不会回到顶部
 */
-(void)reloadDataDerectly;

@end
