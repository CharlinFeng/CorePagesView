//
//  CoreLTVC.m
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CoreLTVC.h"
#import "LTCell.h"


@interface CoreLTVC ()


@end





@implementation CoreLTVC



-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.tableView.tableFooterView=[[UIView alloc] init];
}


/**
 *  模型配置正确。框架开始运作。
 */
-(void)workBegin{
    
    [super workBegin];
    
    self.tableView.rowHeight=self.configModel.rowHeight;
}



/**
 *  重新加载数据
 */
-(void)reloadData{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}



/**
 *  有多少组
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



/**
 *  共有多少行
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}




/**
 *  cell
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //子类真实实例化，父类多态接收
    LTCell *cell=[self.configModel.ViewForCellClass cellWithTableView:tableView];
    
    //数据传递
    cell.indexPath=indexPath;
    
    //模型传递
    cell.model=self.dataList[indexPath.row];
    
    return cell;
}




/**
 *  tableView
 */
-(UITableView *)tableView{
    
    if(_tableView==nil){
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        
        _tableView=tableView;
        tableView.delegate=self;
        tableView.dataSource=self;
        [self.view addSubview:tableView];
        
        tableView.translatesAutoresizingMaskIntoConstraints=NO;
        NSDictionary *views=NSDictionaryOfVariableBindings(tableView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:views]];
    }
    
    return _tableView;
}



/**
 *  scrollView
 */
-(UIScrollView *)scrollView{
    return self.tableView;
}


/**
 *  代理方法
 */

/**
 *  选中行
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

/**
 *  反选中行
 */
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
