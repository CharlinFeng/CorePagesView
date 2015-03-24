//
//  OrderListTVC.m
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "OrderListTVC.h"

@interface OrderListTVC ()

@end

@implementation OrderListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.borderColor=[UIColor brownColor].CGColor;
    self.view.layer.borderWidth=1.0f;
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%i:viewDidAppear显示",_index);
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    NSLog(@"%i:viewDidDisappear消失",_index);
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
