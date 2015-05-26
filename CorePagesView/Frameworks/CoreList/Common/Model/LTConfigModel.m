//
//  CoreLTVCConfigModel.m
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "LTConfigModel.h"

@implementation LTConfigModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //模型初始化
        [self modelPrepare];
    }
    return self;
}




/**
 *  模型初始化
 */
-(void)modelPrepare{
   
    //请求方式：GET
    self.httpMethod=LTConfigModelHTTPMethodGET;
    
    //安装方式
    self.refreshControlType=LTConfigModelRefreshControlTypeBoth;
    
    //更新周期
    self.cycle=5 * 60.0f;
    
    //pagesize
    self.pageSize=10;
    
    //pageSizeName
    self.pageSizeName=@"pagesize";
    
    //pageName
    self.pageName=@"page";
    
    //pageStartValue
    self.pageStartValue=1;
    
    //cellHeight
    self.rowHeight=44.0f;
}





-(NSInteger)pageSize{
    
    if(_pageSize<10){
        _pageSize =10;
    }
    
    return _pageSize;
}


-(void)setParams:(NSDictionary *)params{
    
    _params=params;
    
    //参数检查
    NSArray *keys=[params allKeys];
    
    if([keys containsObject:@"p"]||[keys containsObject:@"page"]||[keys containsObject:@"pagesize"]||[keys containsObject:@"pageSize"]) NSLog(@"参数中请不要带入page信息");
}




@end
