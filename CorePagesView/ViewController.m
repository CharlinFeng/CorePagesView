//
//  ViewController.m
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "CorePagesView.h"
#import "OrderListTVC.h"



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
}



-(CorePagesView *)pagesView{
    
    if(_pagesView==nil){
        
        OrderListTVC *list0TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list0TVC.index=0;
        list0TVC.titleStr=@"未接单";
        
        OrderListTVC *list1TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list1TVC.index=1;
        list1TVC.titleStr=@"接单中";
        
        OrderListTVC *list2TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list2TVC.index=2;
        list2TVC.titleStr=@"审核中";
        
        OrderListTVC *list3TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list3TVC.index=3;
        list3TVC.titleStr=@"已完成";
        
        OrderListTVC *list4TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list4TVC.index=4;
        list4TVC.titleStr=@"未接单";
        
        OrderListTVC *list5TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list5TVC.index=5;
        list5TVC.titleStr=@"接单中";
        
        OrderListTVC *list6TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list6TVC.index=6;
        list6TVC.titleStr=@"审核中";
        
        OrderListTVC *list7TVC=[[OrderListTVC alloc] initWithStyle:UITableViewStylePlain];
        list7TVC.index=7;
        list7TVC.titleStr=@"已完成";
        
        CorePageModel *model0=[CorePageModel model:list0TVC pageBarName:@"已完成"];
        CorePageModel *model1=[CorePageModel model:list1TVC pageBarName:@"未接单"];
        CorePageModel *model2=[CorePageModel model:list2TVC pageBarName:@"接单中"];
        CorePageModel *model3=[CorePageModel model:list3TVC pageBarName:@"审核中"];
        CorePageModel *model4=[CorePageModel model:list4TVC pageBarName:@"已完成已"];
        
        CorePageModel *model5=[CorePageModel model:list5TVC pageBarName:@"未接单"];
        CorePageModel *model6=[CorePageModel model:list6TVC pageBarName:@"接单"];
        CorePageModel *model7=[CorePageModel model:list7TVC pageBarName:@"审核中"];
        
        
        NSArray *pageModels=@[model0,model1,model2,model3,model4,model5,model6,model7];

        _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels];
    }
    
    return _pagesView;
}


@end
