//
//  NewsListCell.m
//  CorePagesView
//
//  Created by 冯成林 on 15/5/26.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsListCell.h"
#import "NewsListModel.h"


@interface NewsListCell ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end



@implementation NewsListCell


/*
 *  数据填充
 */
-(void)dataFill{
    
    //类型强转
    NewsListModel *model =(NewsListModel *) self.model;
    
    _indexLabel.text = [NSString stringWithFormat:@"%@",@(model.hostID)];
    
    _titleLabel.text = model.title;
    
    _contentLabel.text = model.content;
}

@end
