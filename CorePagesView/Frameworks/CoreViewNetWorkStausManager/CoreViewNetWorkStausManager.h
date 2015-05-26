//
//  CoreViewNetWorkStausManager.h
//  CoreViewNetWorkStausManager
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    
    //加载中有图片
    CMTypeLoadingWithImage=0,
    
    //加载中无图片
    CMTypeLoadingWithoutImage,
    
    //文字模式，强制显示图片，没有indicator控件
    CMTypeNormalMsgWithImage,
    
    //错误模式：此模型下block才会生效，其他模式下block均被忽略
    CMTypeError,
    
}CMType;



@interface CoreViewNetWorkStausManager : NSObject




+(void)show:(UIView *)view type:(CMType)type msg:(NSString *)msg subMsg:(NSString *)subMsg offsetY:(CGFloat)offsetY failClickBlock:(void(^)())failClickBlock;


+(void)dismiss:(UIView *)view;


@end
