//
//  CoreLTVC_ReadME.h
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#ifndef CoreLTVC_CoreLTVC_ReadME_h
#define CoreLTVC_CoreLTVC_ReadME_h

/*
 
 使用说明：
 
 
 一.框架说明：
 
 （1）本框架集成了没有缓存功能的TableView列表、CollectionView列表。
 
 （2）本框架依赖以下框架：CoreArchive、MJExtension、CoreHttp、CoreRefresh、CoreViewNetWorkStausManager
 
 （3）使用前，一定要清醒的认识到，父类控制器一个ViewController，他里面分别装有TableView和CollectionView，并非纯正的TableViewVC和CollectionViewVC,因为这样很难统一封装网络请求及上拉下拉加载业务。
 
 
 
 二、使用步骤：
 
 1.UITableViewMVC的集成：
 （1）控制器：  建立控制器，继承自CoreLTVC，建立LTConfigModel模型并传递。
 （2）视图：    建立视图cell，继承自LTCell，重写+(instancetype)cellPrepare方法，创建cell（父类默认从同名Nib创建，也可自行使用代码创建，注意cell从nib创建，nib中需要指定和类名相同的rid。）。
 （3）模型：    继承通用模型，继承自CoreListCommonModel：重写+(NSArray *)modelPrepare:方法，解析并返回列表的字典数组。
 
 2.UICollectionViewMVC的集成：
 （1）控制器：  建立控制器，继承自CoreLCVC，控制器内部建立UICollectionViewFlowLayout及LTConfigModel模型并传递。
 （2）视图cell：建立cell，继承自LCCell，内部实现-(void)dataFill即可。（注意cell从nib创建，nib中需要指定和类名相同的rid。）
 （3）模型：    建立模型，继承自CoreListCommonModel，重写+(NSArray *)modelPrepare:方法，解析并返回列表的字典数组。
 
 */



#endif
