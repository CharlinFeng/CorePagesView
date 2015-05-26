//
//  CMView.m
//  CoreViewNetWorkStausManager
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CMView.h"


@interface CMView ()

/**
 *  控件
 */
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *idv;

@property (strong, nonatomic) IBOutlet UILabel *msgLabel;

@property (strong, nonatomic) IBOutlet UILabel *subMsgLabel;








/**
 *  值
 */
@property (nonatomic,assign) CMType type;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,copy) NSString *subMsg;

@property (nonatomic,assign) CGFloat offsetY;



/**
 *  约束
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *msgLabelMarginConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *idvMarginConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subMsgMarginConstraint;

@property (nonatomic,copy) void (^failClickBlock)();

@end




@implementation CMView

+(instancetype)cmViewWithType:(CMType)type msg:(NSString *)msg subMsg:(NSString *)subMsg offsetY:(CGFloat)offsetY failClickBlock:(void(^)())failClickBlock{
    
    CMView * cmView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    
    cmView.type=type;
    
    cmView.msg=msg;
    
    cmView.subMsg=subMsg;
    
    cmView.offsetY=offsetY;
    
    if(CMTypeError == type) cmView.failClickBlock=failClickBlock;
    
    return cmView;
}



/**
 *  set方法修理布局
 */
-(void)setType:(CMType)type{
    
    if(_type == type) return;
    
    _type=type;
    
    if(CMTypeLoadingWithoutImage == type){//不显示图片
        
        //移除视图控件
        [_imageView removeFromSuperview];
        
        _idvMarginConstraint.constant=20;
        
    }
    
    _idv.hidden=(CMTypeNormalMsgWithImage == type || CMTypeError == type);
}


-(void)setMsg:(NSString *)msg{
    
    if(msg==nil){
        [_msgLabel removeFromSuperview];
        _subMsgMarginConstraint.constant=-20;
        return;
    }
    
    _msg=msg;

    _msgLabel.text=msg;
}


-(void)setSubMsg:(NSString *)subMsg{
    
    if(subMsg==nil){
        [_subMsgLabel removeFromSuperview];
        
        if(CMTypeLoadingWithImage == _type){
            _idvMarginConstraint.constant=-56;
        }
        
        return;
    }
    
    _subMsg=subMsg;
    
    _subMsgLabel.text=subMsg;
}



/**
 *  处理布局
 */
-(void)didMoveToSuperview{
    
    [super didMoveToSuperview];
    
    UIView *superView=self.superview;
    
    if(superView==nil) return;
    
    UIView *selfView=self;
    
    self.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSDictionary *views=NSDictionaryOfVariableBindings(selfView);
    
    NSString *vfl_H=@"";
    NSString *vfl_V=@"";
    NSDictionary *metrics=nil;
    
    
    if([superView isKindOfClass:[UIScrollView class]]){
        
        UIScrollView *scrollView=(UIScrollView *)superView;
        
        CGSize contentSize=scrollView.contentSize;
        
        BOOL hasContentSize=(CGSizeEqualToSize(contentSize, CGSizeZero));
        
        CGSize size=CGSizeZero;
        if(hasContentSize){
            size=scrollView.contentSize;
        }else{
            size=scrollView.frame.size;
        }
        
        metrics=@{@"w":@(size.width),@"h":@(size.height),@"y":@(_offsetY)};
        vfl_H=@"H:|-0-[selfView(==w)]-0-|";
        vfl_V=@"V:|-y-[selfView(==h)]-0-|";

    }else{
        
        metrics=@{@"y":@(_offsetY)};
        
        vfl_H=@"H:|-0-[selfView]-0-|";
        vfl_V=@"V:|-y-[selfView]-0-|";
    }
    
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_H options:0 metrics:metrics views:views]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_V options:0 metrics:metrics views:views]];
}


- (IBAction)btnClick:(id)sender {
    
    if(CMTypeError == _type && _failClickBlock!=nil) _failClickBlock();
}




@end
