//
//  CLCell.m
//  CoreListMVC
//
//  Created by 沐汐 on 15-3-11.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "LCCell.h"

@implementation LCCell



-(void)setModel:(CoreListCommonModel *)model{
    
    //记录
    _model=model;
    
    //调用数据填充方法
    [self dataFill];
}



/**
 *  填充数据：等待子类实现
 */
-(void)dataFill{}






@end
