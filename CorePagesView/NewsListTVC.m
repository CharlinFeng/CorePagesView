//
//  NewsListTVC.m
//  CorePagesView
//
//  Created by 冯成林 on 15/5/26.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsListTVC.h"
#import "NewsListModel.h"
#import "NewsListCell.h"





@interface NewsListTVC ()

@end

@implementation NewsListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //模型配置
    [self config];
    
    self.view.layer.borderColor = [UIColor redColor].CGColor;
    self.view.layer.borderWidth = 5.0f;
}

/**
 *  模型配置
 */
-(void)config{
    
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url
    configModel.url=@"http://211.149.151.92/Carpenter/index.php/Info/testdata";
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    //模型类
    configModel.ModelClass=[NewsListModel class];
    //cell类
    configModel.ViewForCellClass=[NewsListCell class];
    //标识
    configModel.lid=NSStringFromClass(self.class);
    //pageName
    configModel.pageName=@"p";
    //pageSizeName
    configModel.pageSizeName=@"pagesize";
    //起始页码
    configModel.pageStartValue=1;
    //行高
    configModel.rowHeight=60;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=NO;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}


@end
