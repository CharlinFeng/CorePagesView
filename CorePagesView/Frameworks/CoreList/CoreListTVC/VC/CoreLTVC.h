//
//  CoreLTVC.h
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//  封装列表




#import <UIKit/UIKit.h>
#import "CoreListVC.h"


@interface CoreLTVC : CoreListVC<UITableViewDataSource,UITableViewDelegate>


/**
 *  tableView
 */
@property (nonatomic,weak) UITableView *tableView;


@end
