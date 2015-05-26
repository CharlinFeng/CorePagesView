//
//  LTCell.m
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "LTCell.h"

@implementation LTCell


/**
 *  从缓存池中取cell封装
 */
+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *rid=NSStringFromClass(self);
    
    LTCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil) cell=[self cellPrepare];
    
    return cell;
}


/**
 *  cell的创建
 */
+(instancetype)cellPrepare{

    LTCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    return cell;
}



-(void)setModel:(CoreListCommonModel *)model{
    
    //记录
    _model=model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //调用数据填充方法
        [self dataFill];
    });
}



/**
 *  填充数据：等待子类实现
 */
-(void)dataFill{}




@end
