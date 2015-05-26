//
//  CoreLTVCConfigModel.h
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//  配置模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    
    //GET
    LTConfigModelHTTPMethodGET=0,
    
    //POST
    LTConfigModelHTTPMethodPOST,
    
}LTConfigModelHTTPMethod;



typedef enum{
    
    //顶部刷新、底部刷新控件均安装
    LTConfigModelRefreshControlTypeBoth=0,
    
    //仅仅安装顶部刷新新控
    LTConfigModelRefreshControlTypeTopRefreshOnly,
    
    //仅仅安装底部刷新新控
    LTConfigModelRefreshControlTypeBottomRefreshOnly,
    
    //顶部刷新、底部刷新控件均不安装，仅仅是利用数据解析的便利
    LTConfigModelRefreshControlTypeNeither,
    
    
}LTConfigModelRefreshControlType;



@interface LTConfigModel : NSObject


/**
 *  ----------------必传参数----------------url、params、ModelClass、ViewForCellClass
 */



/**
 *  url地址
 */
@property (nonatomic,copy) NSString *url;


/**
 *  参数:注意参数中无需考虑page及pageSize
 */
@property (nonatomic,strong) NSDictionary *params;



/**
 *  数据模型类
 */
@property (nonatomic,assign) Class ModelClass;


/**
 *  cell所用类:注，cell默认从xib创建
 */
@property (nonatomic,assign) Class ViewForCellClass;






/**
 *  ----------------选填参数----------------pageStartValue、pageName、pageSizeName、pageSize、cycle、refreshControlType、httpMethod、rowHeight、lid
 */

/**
 *  页面的起始值：默认为1
 */
@property (nonatomic,assign) NSInteger pageStartValue;


/**
 *  pageName:默认为page
 */
@property (nonatomic,copy) NSString *pageName;

/**
 *  pageSizeName：默认为pagesize
 */
@property (nonatomic,copy) NSString *pageSizeName;



/**
 *  pageSize：强制要求最低是10个
 */
@property (nonatomic,assign) NSInteger pageSize;


/**
 *  更新数据周期：默认为5分钟,单位是秒
 */
@property (nonatomic,assign) NSTimeInterval cycle;


/**
 *  刷新控件安装方式:默认为均安装
 */
@property (nonatomic,assign) LTConfigModelRefreshControlType refreshControlType;


/**
 *  请求方式：默认为GET方式
 */
@property (nonatomic,assign) LTConfigModelHTTPMethod httpMethod;

/**
 *  cell的行高:默认是44
 */
@property (nonatomic,assign) CGFloat rowHeight;


/**
 *  控制器唯一标识：用于定期更新数据
 */
@property (nonatomic,copy) NSString *lid;


/**
 *  是否移除返回顶部功能按钮，默认不移除
 */
@property (nonatomic,assign) BOOL removeBackToTopBtn;


@end
