//
//  CoreListCommonModel.m
//  CoreListMVC
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CoreListCommonModel.h"

@implementation CoreListCommonModel



+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"hostID":@"id"};
}






/**
 *  数据处理
 *
 *  @param obj 原始数据
 *
 *  @return 数组
 */
+(NSArray *)modelPrepare:(id)obj{
    return obj;
}



/**
 *  模型数组校验
 */
+(BOOL)check:(NSArray *)models{
    
    if(models==nil || models.count==0){
        NSLog(@"当前数据为空：当前模型为：%@",NSStringFromClass(self));
        return NO;
    }
    
    for (CoreListCommonModel *model in models) {
        
        if([model isKindOfClass:self]) continue;
        
        NSLog(@"\n当前数组里面装的不是%@模型，\n数组内容为：%@",NSStringFromClass(self),models);
        
        return NO;
    }
    
    return YES;
}









/**
 *  模型数组对比
 */
+(BOOL)ListModel:(NSArray *)modelArray1 isEqual:(NSArray *)modelArray2{
    
    //排序
    NSArray *sortedArray1 = [self modelArrayAsc:modelArray1];
    NSArray *sortedArray2 = [self modelArrayAsc:modelArray2];
    
    //1.对比hostID数组，如果hostID数组都不一致，则数组一定不相同
    NSArray *idArray1 = [sortedArray1 valueForKeyPath:@"hostID"];
    NSArray *idArray2 = [sortedArray2 valueForKeyPath:@"hostID"];
    
    if(![idArray1 isEqualToArray:idArray2]) return NO;
    
    //id数组一样，则需要详细对比整体内容
    //模型数组转字典数组
    NSArray *dictArray1=[NSObject keyValuesArrayWithObjectArray:sortedArray1];
    NSArray *dictArray2=[NSObject keyValuesArrayWithObjectArray:sortedArray2];
    
    if(![dictArray1 isEqualToArray:dictArray2]) {
        NSLog(@"不相同");
        return NO;
    }else{
        NSLog(@"相同");
    }
    
    return YES;
}



/**
 *  模型数组升序排列
 *
 *  @param modelArray 原数组
 *
 *  @return 升序数组
 */
+(NSArray *)modelArrayAsc:(NSArray *)modelArray{
    
    NSArray *sortedModelArray = [modelArray sortedArrayUsingComparator:^NSComparisonResult(CoreListCommonModel *m1, CoreListCommonModel *m2) {
        
        if(m1.hostID<m2.hostID) return NSOrderedAscending;
        if(m1.hostID>m2.hostID) return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    
    return sortedModelArray;
}



@end
