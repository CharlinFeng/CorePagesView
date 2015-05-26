//
//  OrderListTVC.m
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "OrderListTVC.h"
#import "UIScrollView+Refresh.h"

@interface OrderListTVC ()

@end

@implementation OrderListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.borderColor=[UIColor brownColor].CGColor;
    self.view.layer.borderWidth=1.0f;
    
    //安装
    [self.tableView addHeaderWithTarget:self action:@selector(header)];
    [self.tableView addFooterWithTarget:self action:@selector(foorter)];

    self.view.layer.borderColor = [UIColor redColor].CGColor;
    self.view.layer.borderWidth = 4.0f;
}


-(void)header{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerSetState:CoreHeaderViewRefreshStateSuccessedResultDataShowing];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"_scrollViewOriginalInset=%@,%@",NSStringFromUIEdgeInsets(self.tableView.contentInset),NSStringFromCGPoint(self.tableView.contentOffset));
    });
}

-(void)foorter{
}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"_scrollViewOriginalInset=%@,%@",NSStringFromUIEdgeInsets(self.tableView.contentInset),NSStringFromCGPoint(self.tableView.contentOffset));
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}





-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    [self.tableView reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *rid=@"rid";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@:%@的第%@行",@(self.index),self.titleStr,@(indexPath.row)];
    
    return cell;
}

-(void)dealloc{
    NSLog(@"被释放");
}


@end
