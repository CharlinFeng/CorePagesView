//
//  CAAnimation+PagesViewBarShake.m
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CAAnimation+PagesViewBarShake.h"

@implementation CAAnimation (PagesViewBarShake)



/**
 *  抖动
 */
+(CAKeyframeAnimation *)shake{
    CAKeyframeAnimation *kfa=[CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    //值
    kfa.values=@[@(10),@(-8),@(6),@(-4),@(2),@(-1),@(0)];
    
    //设置时间
    kfa.duration=0.6f;
    
    //是否重复
    kfa.repeatCount=0;
    
    //是否反转
    kfa.autoreverses=NO;
    
    //完成移除
    kfa.removedOnCompletion=YES;
    
    return kfa;
}


@end
