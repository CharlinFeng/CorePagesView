//
//  CoreTabsView.m
//  CoreTabsVC
//
//  Created by 冯成林 on 15/3/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CorePagesView.h"
#import "CorePagesBarView.h"


@interface CorePagesView ()<UIScrollViewDelegate>{
    
    
    CorePagesViewConfig  *_config;
}

@property (strong, nonatomic) IBOutlet CorePagesBarView *pagesBarView;

@property (nonatomic,assign) CGFloat width;


/**
 *  性能优化字典
 */
@property (nonatomic,strong) NSMutableDictionary *indexDict;



/**
 *  本视图所属的控制器
 */
@property (nonatomic,weak) UIViewController *ownerVC;


/**
 *  分页模型数组
 */
@property (nonatomic,strong) NSArray *pageModels;



/**
 *  最大的页码
 */
@property (nonatomic,assign) NSUInteger maxPage;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pagesBarViewHConstraint;

@property (nonatomic,assign) CGFloat barH;

@property (nonatomic,assign) CGRect originalFrame;


/**
 *  记录offset的字典
 */
@property (nonatomic,strong) NSMutableDictionary *offsetDict;


/**
 *  记录insets的字典
 */
@property (nonatomic,strong) NSMutableDictionary *insetsDict;



/**
 *  记录出现过的view
 */
@property (nonatomic,strong) NSMutableArray *calViewsM;


/**
 *  页码
 */
@property (nonatomic,assign) NSUInteger page;


/**
 *  减速前的页码
 */
@property (nonatomic,assign) NSUInteger deceleratingPage;


/**
 *  上一次scrollView在didScroll中计算页码所使用的宽度
 */
@property (nonatomic,assign) CGFloat lastCalWidth;


@property (nonatomic,strong) CorePagesViewConfig *config;

@end



@implementation CorePagesView


/**
 *  快速实例化对象
 *
 *  @param ownerVC    本视图所属的控制器
 *  @param pageModels 模型数组
 *  @param config     配置
 *
 *  @return 实例
 */
+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels config:(CorePagesViewConfig *)config{
    
    CorePagesView *pagesView=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //记录所属控制器
        pagesView.ownerVC=ownerVC;
        
        //模型数组
        pagesView.pageModels=pageModels;
        
        //设置配置
        pagesView.config = config;
        
    });
    
    return pagesView;
}





-(void)awakeFromNib{
    
    [super awakeFromNib];

    self.scrollView.pagingEnabled=YES;

    //注册屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //设置scrollView的代理
    self.scrollView.delegate=self;
    
    //隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    //高度修复
    _pagesBarViewHConstraint.constant =self.config.barViewH;
    
    //初始化
    self.lastCalWidth=self.width;
    
    //事件处理
    [self event];
    
    //设置值
    _scrollView.contentInset =UIEdgeInsetsMake(self.config.barViewH, 0, 0, 0);
    _scrollView.contentOffset = CGPointMake(0, -self.config.barViewH);
    self.pagesBarView.config = self.config;

}



-(void)dealloc{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  事件处理
 */
-(void)event{
    
    
     __weak typeof(self) weakSelf=self;
    self.pagesBarView.btnActionBlock=^(CorePagesBarBtn *btn,NSUInteger page){
        [weakSelf jumpToPage:page];
    };
}





/**
 *  注册屏幕旋转
 */
-(void)deviceRotate{

    self.pagesBarView.page=self.page;
    [self scrollViewActionWithPage:self.page];
    [self adjustContentSize];
}



-(void)setPageModels:(NSArray *)pageModels{
    
    _pageModels=pageModels;
    
    //模型检查
    BOOL res=[CorePageModel modelCheck:pageModels];
    
    if(!res){
        
        NSLog(@"您传的pageModels数组格式不正确，请检查！");
        
        return;
    }
    
    //数据传递
    self.pagesBarView.pageModels=pageModels;
    
    
    //调整contentSize
    [self adjustContentSize];
    
    //性能优化：最开始只加第一个
    [self handleForPage:0];
}


/**
 *  调整contentSize
 */
-(void)adjustContentSize{
    CGFloat width=self.width;
    CGFloat num=self.pageModels.count;
    if(num<=0) num=1;
    self.scrollView.contentSize=CGSizeMake(width * num, 0);
}


-(void)handleForPage:(NSUInteger)page{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CorePageModel *pageModel=_pageModels[page];
        
        //判断页面是否已经添加
        if(_indexDict!=nil && [_indexDict.allKeys containsObject:@(page)]){
            return;
        }
        
        //添加子控制器
        [self.ownerVC addChildViewController:pageModel.pageVC];
        
        //添加视图
        UIView *subView=pageModel.pageVC.view;
        subView.tag=100;
        
        [self.scrollView addSubview:subView];

        if(subView != nil){
            
            //字典记录
            [self.indexDict setObject:subView forKey:@(page)];
        }

        [self setNeedsLayout];
    });
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.originalFrame=self.bounds;
    
    NSArray *subViews=self.scrollView.subviews;
    
    CGRect frame=_originalFrame;
    
    NSUInteger index=0;

    for (NSInteger i=0; i<subViews.count; i++) {
        
        UIView *subView=subViews[i];

        //非我们的子控件不需要处理
        if([subView isKindOfClass:[UIImageView class]]) continue;
        
        index=[self findIndex:subView];
 
        if([subView isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView=(UIScrollView *)subView;

            if(![self.calViewsM containsObject:@(index)]){
                //处理insets
                UIEdgeInsets insets=scrollView.contentInset;
                insets.top+=self.barH;
                scrollView.contentInset=insets;
                
                //处理offset
                CGPoint offset=scrollView.contentOffset;
                offset.y+=-self.barH;
                scrollView.contentOffset=offset;
                
                //记录subView
                [self.calViewsM addObject:@(index)];
            }
            
        }else{
            self.scrollView.contentInset=UIEdgeInsetsMake(self.config.barViewH, 0, 0, 0);
            
            frame.size.height=_originalFrame.size.height - self.config.barViewH;
        }
        
        

        frame.origin.x= frame.size.width * index;
        
        subView.frame=frame;
    }
}



-(NSUInteger)findIndex:(UIView *)subView{
    
    if(_pageModels==nil || _pageModels.count==0) return 0;
    
    for (CorePageModel *pageModel in _pageModels) {
        
        if(pageModel.pageVC.view != subView) continue;
        
        return [_pageModels indexOfObject:pageModel];
    }
    
    return 0;
}





-(CGFloat)width{
    return self.bounds.size.width;
}

-(CGFloat)barH{
    
    return _pagesBarViewHConstraint.constant;
    
}


-(void)setPage:(NSUInteger)page{
    
    if(_page==page) return;

    if(page>=self.maxPage) page=self.maxPage;

    if(page <=0) page=0;
    
    _page=page;
    
    //页码传递
    self.pagesBarView.page=page;
    
    if(self.scrollView.isDragging) return;
    
    //页码处理并加载视图
    [self pageHandle:YES];
    
    //处理视图生命周期
    [self handleViewLife:YES];
}


/**
 *  页码改变，scrollView做出响应
 */
-(void)scrollViewActionWithPage:(NSUInteger)page{
    
    CGFloat x =self.width * page;
    
    CGPoint offset=CGPointMake(x, -self.config.barViewH);
    
    [UIView animateWithDuration:self.config.animDuration animations:^{
        [self.scrollView setContentOffset:offset animated:NO];
    }];
}




/**
 *  scrollView代理方法区
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX=scrollView.contentOffset.x;
    
    CGFloat width=self.width;
    
    if(_lastCalWidth != width && _lastCalWidth!=600){
        
        _lastCalWidth=width;
        return;
    }
    
    //获取页面
    NSInteger page=(offsetX / width) + .5f;

    self.page=page;
    
    [self handleForPage:self.page];
    
    _lastCalWidth=width;
}






-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.scrollView.isDragging) return;
    self.deceleratingPage=self.page;
}

/**
 *  处理视图生命周期
 */
-(void)handleViewLife:(BOOL)isTopBtnClick{
    
    //尝试遍历
    [_indexDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIView *subView, BOOL *stop) {
        
        if(![key isEqualToNumber:@(_page)]){
            
            if(isTopBtnClick){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(!self.scrollView.isDragging){
                        [subView removeFromSuperview];
                    }
                });
            }else{
                if(!self.scrollView.isDragging){
                    [subView removeFromSuperview];
                }
            }
            
            [_indexDict removeObjectForKey:key];
//            NSLog(@"index=%@的视图被移除",key);
            

        }else{
//            NSLog(@"index=%@的视图被保留",key);
        }
    }];
}





-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //页码处理并加载视图
    [self pageHandle:NO];
}



/**
 *  页码处理并加载视图
 */
-(void)pageHandle:(BOOL)topBtnClick{
    
    if(_pageModels==nil ||_pageModels.count==0) return;
    
    
    //取出下一个页面的页码
    NSUInteger prePage=_page-1;
    NSUInteger nowPager=_page;
    NSUInteger nextPage=_page+1;
    

    if(nextPage >= self.maxPage) nextPage=self.maxPage;
    if(prePage>=self.maxPage-1)prePage=_maxPage-1;
    
    //取出对应的模型
    if(topBtnClick){
        [self handleForPage:nowPager];
    }else{
        [self handleForPage:prePage];
        [self handleForPage:nextPage];
        
    }
}



/**
 *  懒加载
 */
-(NSMutableDictionary *)indexDict{
    
    if(_indexDict==nil){
        _indexDict=[NSMutableDictionary dictionary];
    }
    
    return _indexDict;
}

-(NSMutableDictionary *)offsetDict{
    
    if(_offsetDict==nil){
        
        _offsetDict=[NSMutableDictionary dictionary];
    }
    
    return _offsetDict;
}

-(NSMutableDictionary *)insetsDict{
    
    if(_insetsDict==nil){
        
        _insetsDict=[NSMutableDictionary dictionary];
    }
    
    return _insetsDict;
}


-(NSMutableArray *)calViewsM{
    
    if(_calViewsM==nil){
        _calViewsM=[NSMutableArray array];
    }
    
    return _calViewsM;
}



-(NSUInteger)maxPage{
    
    if(_maxPage<=0 && _pageModels!=nil){
        _maxPage=_pageModels.count - 1;
    }
    
    return _maxPage;
}

-(CorePagesViewConfig *)config{
    
    if(_config == nil){
        
        _config = [[CorePagesViewConfig alloc] init];
    }
    
    return _config;
}


-(void)setConfig:(CorePagesViewConfig *)config{
    
    _config = config;
    
    self.pagesBarViewHConstraint.constant = config.barViewH;
    self.pagesBarView.config = config;
}


-(void)setDeceleratingPage:(NSUInteger)deceleratingPage{
    
    if(_deceleratingPage == deceleratingPage) return;
    
    _deceleratingPage = deceleratingPage;
   
    //处理视图生命周期
    [self handleViewLife:NO];
}

/** 中转到指定页码 */
-(void)jumpToPage:(NSUInteger)jumpPage{
    self.page = jumpPage;
    [self scrollViewActionWithPage:self.page];
}

@end
