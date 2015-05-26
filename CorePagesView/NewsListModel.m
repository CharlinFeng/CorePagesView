//
//  NewsListModel.m
//  CorePagesView
//
//  Created by 冯成林 on 15/5/26.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel

+(NSArray *)modelPrepare:(id)obj{
    
    return obj[@"data"];
}

@end
