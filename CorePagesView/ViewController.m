//
//  ViewController.m
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "CorePagesView.h"
#import "NewsListTVC.h"



@interface ViewController ()

@property (nonatomic,strong) CorePagesView *pagesView;

@end

@implementation ViewController



-(void)loadView{
    self.view=self.pagesView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pagesView jumpToPage:3];
    });
}



-(CorePagesView *)pagesView{
    
    if(_pagesView==nil){
        
        NewsListTVC *tvc1 = [[NewsListTVC alloc] init];
        NewsListTVC *tvc2 = [[NewsListTVC alloc] init];
        NewsListTVC *tvc3 = [[NewsListTVC alloc] init];
        NewsListTVC *tvc4 = [[NewsListTVC alloc] init];
        
        
        CorePageModel *model1=[CorePageModel model:tvc1 pageBarName:@"新闻1"];
        CorePageModel *model2=[CorePageModel model:tvc2 pageBarName:@"新闻2"];
        CorePageModel *model3=[CorePageModel model:tvc3 pageBarName:@"新闻3"];
        CorePageModel *model4=[CorePageModel model:tvc4 pageBarName:@"新闻4"];
        
        
        NSArray *pageModels=@[model1,model2,model3,model4];
        
        
        //自定义配置
        CorePagesViewConfig *config = [[CorePagesViewConfig alloc] init];
        
        config.isBarBtnUseCustomWidth = YES;
        
        config.barBtnWidth = [UIScreen mainScreen].bounds.size.width/4;
        
        config.barViewH = 40;
        
        _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels config:config];

    }
    
    return _pagesView;
}


@end
