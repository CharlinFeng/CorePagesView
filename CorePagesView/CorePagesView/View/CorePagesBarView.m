//
//  TabsBarView.m
//  CoreTabsVC
//
//  Created by 冯成林 on 15/3/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CorePagesBarView.h"
#import "CorePageModel.h"
#import "CorePagesViewConst.h"
#import "CorePagesViewConst.h"
#import "CAAnimation+PagesViewBarShake.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface CorePagesBarView ()



/**
 *  字体：默认15
 */
@property (nonatomic,strong) UIFont *barFont;

@property (nonatomic,strong) NSArray *btns;


/**
 *  选中的按钮
 */
@property (nonatomic,strong) CorePagesBarBtn *selectedBtn;


/**
 *  线条
 */
@property (nonatomic,strong) UIView *lineView;


/**
 *  已经初始化选取了第一个按钮
 */
@property (nonatomic,assign) BOOL hasSelectedFirstBtn;


/**
 *  页码跨度大
 */
@property (nonatomic,assign) BOOL pageChangeMax;


@end




@implementation CorePagesBarView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //隐藏水平滚动条
    self.showsHorizontalScrollIndicator=NO;
}


-(void)setPageModels:(NSArray *)pageModels{
    
    //记录
    _pageModels=pageModels;
    
    BOOL res=[CorePageModel modelCheck:pageModels];
    
    if(!res) return;
    
    [self btnsPrepare];
}



/**
 *  创建按钮
 */
-(void)btnsPrepare{

    NSMutableArray *arrayM=[NSMutableArray arrayWithCapacity:_pageModels.count];
    
    
    for (NSInteger i=0; i<_pageModels.count; i++) {
        
        CorePageModel *pageModel=_pageModels[i];
        
        CorePagesBarBtn *btn=[CorePagesBarBtn buttonWithType:UIButtonTypeCustom];
        
        NSString *str=pageModel.pageBarName;
        
        CGSize fontSize=[str sizeWithFont:self.barFont];
        
        //设置文字
        [btn setTitle:str forState:UIControlStateNormal];
        
        //设置tag
        btn.tag=i;
        
        //设置字体
        btn.titleLabel.font=self.barFont;
        
        CGSize size=CGSizeMake(fontSize.width, CorePagesBarViewH);
        
        btn.bounds=(CGRect){CGPointZero,size};
        
        [self addSubview:btn];
        
        [arrayM addObject:btn];
    }

    self.btns=arrayM;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat count=self.btns.count;
    
    __block NSInteger i=0;
    
    
    //调整frame
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        
        if([subView isKindOfClass:[CorePagesBarBtn class]]){//过滤其他控件
            
            CorePagesBarBtn *btn=(CorePagesBarBtn *)subView;
            
            //添加事件
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if(i==0 && !_hasSelectedFirstBtn){
                self.selectedBtn=btn;
                _hasSelectedFirstBtn=YES;
            }
            
            //获取此btn的index
            NSUInteger index=[_btns indexOfObject:btn];
            
            if(index>=count) return;
            
            
            //得到并赋值frame
            CGRect frame=btn.bounds;
            
            if(index!=0){
                //获取上一个控件
                //上一个控件的indexPre
                NSUInteger indexPre=index-1;
                CorePagesBarBtn *btnPre=_btns[indexPre];
                
                //设置当前按钮的x
                CGFloat x=CGRectGetMaxX(btnPre.frame) + CorePagesBarBtnMargin;
                
                frame.origin.x = x;
            }else{
                
                frame.origin.x = CorePagesBarScrollMargin;
            }
            
            btn.frame=frame;
            
            i++;
        }
    }];
    
    //调整contentSize
    CGFloat width=CGRectGetMaxX([self.btns.lastObject frame]) + CorePagesBarScrollMargin;
    
    self.contentSize=CGSizeMake(width, 0);
}



-(void)btnClick:(CorePagesBarBtn *)btn{
    
    self.selectedBtn=btn;
    
    //执行block
    if(_btnActionBlock!=nil) _btnActionBlock(btn,btn.tag);
}




-(void)setSelectedBtn:(CorePagesBarBtn *)selectedBtn{
    
    if(_selectedBtn == selectedBtn) return;
    
    if(_selectedBtn != nil) _selectedBtn.selected=NO;
    
    selectedBtn.selected=YES;
    
    self.pageChangeMax=ABS(_selectedBtn.tag - selectedBtn.tag)>1;
    
    if(self.pageChangeMax){
        NSLog(@"跨度大");
    }else{
        NSLog(@"跨度小");
    }
    
    //根据btn显示正确的lineView的frame
    BOOL isFirstBtn=_selectedBtn==nil;
    [self adjustLineViewFrameWithBtn:selectedBtn isFirstBtn:isFirstBtn];
    
    
    _selectedBtn=selectedBtn;
    
    //按钮选中，scrollView需要自行调整位置
    [self scrollViewFitContentOffsetWithBtnSelected];
}


/**
 *  按钮选中，scrollView需要自行调整位置,尽量使得当前选中的btn位于scrollView的正中间
 */
-(void)scrollViewFitContentOffsetWithBtnSelected{
    
    //如果数量不够，则不需要调整
    if(self.contentSize.width<=self.bounds.size.width) return;

    //取出当前btn的中点
    CGFloat centerX=_selectedBtn.center.x;
    
    //此时控件的宽度
    CGFloat scrollViewW=self.bounds.size.width;
    
    //计算最左侧的x值
    CGFloat leftX=centerX - scrollViewW * 0.5f;
    
    //最左侧处理
    if(leftX<0) leftX=0;
    
    //最右侧处理
    CGFloat maxOffsetX=self.contentSize.width - scrollViewW;
    if(leftX>=maxOffsetX) leftX=maxOffsetX;
    
    
    //构建contentOffset
    CGPoint offset=CGPointMake(leftX, 0);
    
    [UIView animateWithDuration:CorePagesAnimDuration animations:^{
        self.contentOffset=offset;
    }];
}





/**
 *  根据btn显示正确的lineView的frame
 */
-(void)adjustLineViewFrameWithBtn:(CorePagesBarBtn *)btn isFirstBtn:(BOOL)isFirstBtn{
    
    //取出btn最小的x和宽度
    CGFloat minX=CGRectGetMinX(btn.frame);
    if(minX<0) minX=CorePagesBarScrollMargin;
    
    CGFloat width=btn.frame.size.width;
    
    CGFloat lineViewX=minX - CorePagesBarLineViewPadding;
    CGFloat lineViewH=2.0f;
    CGFloat lineViewY=CorePagesBarViewH - lineViewH;
    CGFloat lineViewW=width + CorePagesBarLineViewPadding * 2;
    
    CGRect frame=CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    if(isFirstBtn){
        self.lineView.frame=frame;
    }else{
        
        [UIView animateWithDuration:CorePagesAnimDuration animations:^{
            self.lineView.frame=frame;
        } completion:^(BOOL finished) {
//            if(!self.pageChangeMax) return;
            [self.lineView.layer addAnimation:[CAAnimation shake] forKey:@"shake"];
        }];
    }
}






-(UIFont *)barFont{
    
    if(!_barFont){
        _barFont=[UIFont systemFontOfSize:CorePagesBarBtnFontPoint];
    }
    
    return _barFont;
}




/**
 *  线条
 */
-(UIView *)lineView{
    
    if(!_lineView){

        _lineView=[[UIView alloc] init];
        
        //设置颜色
        _lineView.backgroundColor=[UIColor redColor];

        [self addSubview:_lineView];
    }
    
    return _lineView;
}



-(void)setPage:(NSUInteger)page{
    
    if(_page==page) return;
 
    _page=page;
    
    //取出对应按钮
    CorePagesBarBtn *btn=self.btns[page];
    
    self.selectedBtn=btn;
}


@end
