//
//  CoreListController.m
//  CoreListMVC
//
//  Created by 沐汐 on 15-3-11.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CoreListVC.h"
#import "LTCell.h"
#import "CoreRefreshEntry.h"
#import "CoreArchive.h"
#import "CoreViewNetWorkStausManager.h"

typedef enum{
    
    //顶部刷新控件请求
    CoreLTVCRequestTypeHeaderRefresh=0,
    
    //底部刷新控件请求
    CoreLTVCRequestTypeFooterRefresh,
    
}CoreLTVCRequestType;



@interface CoreListVC ()<UIScrollViewDelegate>


/**
 *  是否已经安装底部刷新控件
 */
@property (nonatomic,assign) BOOL hasData;


/**
 *  page值
 */
@property (nonatomic,assign) NSInteger page,tempPage;



/**
 *  最新的数组模型：顶部刷新的第一个对象
 */
@property (nonatomic,strong) CoreListCommonModel *latestModel;


/**
 *  url
 */
@property (nonatomic,copy) NSString *url;



/**
 *  是否允许安装顶部刷新控件
 */
@property (nonatomic,assign) BOOL canSetupHeaderRefreshControl;



/**
 *  是否允许安装底部刷新控件
 */
@property (nonatomic,assign) BOOL canSetupFooterRefreshControl;



/**
 *  是否已经安装了底部刷新控件
 */
@property (nonatomic,assign) BOOL alreadySetupFooterRefreshControl;


/**
 *  scrollview的高度，用于判断数据量否超过一页
 */
@property (nonatomic,assign) CGFloat scrollH;

/**
 *  顶部刷新返回的数据的服务器id数组
 */
@property (nonatomic,strong) NSArray *headerRefreshDataListModelArray;


@property (nonatomic,assign) CoreLTVCRequestType currentType;


/**
 *  返回顶部按钮
 */
@property (nonatomic,strong) UIButton *backTopBtn;


@property (nonatomic,assign) BOOL isHideBackTopBtn;


/**
 *  原始的contentOffset值
 */
@property (nonatomic,assign) CGPoint oringinalOffset;




@end


const CGFloat CoreViewNetWorkStausManagerOffsetY=0;



@implementation CoreListVC


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    //控制器相关配置
    [self vcPrepare];
}



/**
 *  控制器相关配置
 */
-(void)vcPrepare{
    self.view.backgroundColor=[UIColor whiteColor];
    self.scrollView.backgroundColor=[UIColor clearColor];
    self.scrollView.delegate=self;
}



-(void)setConfigModel:(LTConfigModel *)configModel{
    
    _configModel=configModel;
    
    //模型配置正确。框架开始运作。
    [self workBegin];
}



/**
 *  视图显示：加载顶部刷新控件
 */
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    //如果dev没有传lid，说明需要实时更新
    if(_configModel.lid==nil){
        
        //需要实时更新
        //触发顶部刷新
        [self triggerTopRefreshAction];
        
    }else{
        
        //定期更新
        //获取上次更新的更新
        NSTimeInterval lastTime=[CoreArchive floatForKey:_configModel.lid];
        
        NSTimeInterval now=[[NSDate date] timeIntervalSince1970];
        
        CGFloat timeDelta=now - lastTime;
        
        if(timeDelta >= _configModel.cycle || !_hasData){
            
            //触发顶部刷新
            [self triggerTopRefreshAction];
            
            //保存时间
            [CoreArchive setFloat:now key:_configModel.lid];
        }
    }
    
    if(!_configModel.removeBackToTopBtn){
        //获取原始的contentOffset值
        if(CGPointEqualToPoint(_oringinalOffset, CGPointZero)) _oringinalOffset=self.scrollView.contentOffset;
    }
}


/**
 *  触发顶部刷新
 */
-(void)triggerTopRefreshAction{
    if(self.canSetupHeaderRefreshControl){
        
        //需要安装顶部刷新控件
        
        //更新周期满了，可以更新
        [self.scrollView headerSetState:CoreHeaderViewRefreshStateNorMal];
        [self.scrollView headerSetState:CoreHeaderViewRefreshStateRefreshing];
        
    }else{
        
        //如果不允许安装顶部刷新控件，直接请求
        [self requestWithRequestType:CoreLTVCRequestTypeHeaderRefresh];
    }
    
    
    if(!_hasData){
        //添加一个网络指示器
        [CoreViewNetWorkStausManager show:self.view type:CMTypeLoadingWithImage msg:@"数据加载中" subMsg:@"请稍等，即将努力请求数据哦" offsetY:CoreViewNetWorkStausManagerOffsetY failClickBlock:nil];
    }

}




/**
 *  视图消失：移除顶部刷新及底部刷新控件
 */
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}




/**
 *  模型配置正确。框架开始运作。
 */
-(void)workBegin{
    
    if(self.canSetupHeaderRefreshControl){
        //添加顶部刷新控件
        [self.scrollView addHeaderWithTarget:self action:@selector(headerRefreshAction)];
    }
    
    //页码从1开始
    _page=_configModel.pageStartValue;
}




/**
 *  顶部刷新
 */
-(void)headerRefreshAction{
    
    if(!_hasData){
        //添加一个网络指示器
        [CoreViewNetWorkStausManager show:self.view type:CMTypeLoadingWithImage msg:@"数据加载中" subMsg:@"请稍等，即将努力请求数据哦" offsetY:CoreViewNetWorkStausManagerOffsetY failClickBlock:nil];
    }
    
    //归位前做一个记录,假如一会顶部刷新没有数据也可恢复数据。
    _tempPage=_page;
    
    //页面归位
    _page=_configModel.pageStartValue;
    [self requestWithRequestType:CoreLTVCRequestTypeHeaderRefresh];
}


/**
 *  底部刷新
 */
-(void)footerRefreshAction{
    _page++;
    [self requestWithRequestType:CoreLTVCRequestTypeFooterRefresh];
}




/**
 *  请求
 *
 *  @param requestType 请求方式
 */
-(void)requestWithRequestType:(CoreLTVCRequestType)requestType{
    
    //记录当前的请求方式（顶部刷新/底部刷新）
    _currentType=requestType;
    
    //GET请求
    if(LTConfigModelHTTPMethodGET == _configModel.httpMethod){
        [self getMethodWithRequestType:requestType]; return;
    }
    
    //POST请求
    if(LTConfigModelHTTPMethodPOST == _configModel.httpMethod){
        [self postMethodWithRequestType:requestType]; return;
    }
    
}



/**
 *  GET请求
 */
-(void)getMethodWithRequestType:(CoreLTVCRequestType)requestType{
    
    NSString *url=[NSString stringWithFormat:@"%@%@",self.url,@(_page)];
    
    [CoreHttp getUrl:url params:_configModel.params success:^(id obj) {
        [self success:obj requestType:requestType];
    } errorBlock:^(CoreHttpErrorType errorType) {
        [self error:errorType requestType:requestType];
    }];
}


/**
 *  POST请求
 */
-(void)postMethodWithRequestType:(CoreLTVCRequestType)requestType{
    
    NSString *url=[NSString stringWithFormat:@"%@%@",self.url,@(_page)];
    
    [CoreHttp postUrl:url params:_configModel.params success:^(id obj) {
        [self success:obj requestType:requestType];
    } errorBlock:^(CoreHttpErrorType errorType) {
        [self error:errorType requestType:requestType];
    }];
}



/**
 *  处理成功
 *  顶部刷新：直接取当前服务器第1页的数据，所以顶部刷新一定会有数据,如果没有数据，则是表示整个列表一条数据都没有。或者是page起始值不对。
 *  底部刷新：可能有数据，可能没有数据
 */
-(void)success:(id)obj requestType:(CoreLTVCRequestType)requestType{
    
    //数据需要经过模型处理
    NSArray *dictsArray=[_configModel.ModelClass modelPrepare:obj];
    
    //查看加载结果
    if(dictsArray==nil || ![dictsArray isKindOfClass:[NSArray class]] || dictsArray.count==0){//没有数据
        
        //没有数据有以下两种情况：
        //1.顶部刷新没有数据
        if(CoreLTVCRequestTypeHeaderRefresh == requestType){
            
            //给出状态
            [self.scrollView headerSetState:CoreHeaderViewRefreshStateSuccessedResultNoMoreData];
            NSLog(@"顶部刷新没有任何数据，可能是列表没有任何数据或者page起始页设置有问题。");
            
            //第一次来就没有数据：提示没有数据
            [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"暂无数据" subMsg:@"没有新数据，点击屏幕获取试试" offsetY:CoreViewNetWorkStausManagerOffsetY failClickBlock:^{
                [self reloadDataWithheaderViewStateRefresh];
            }];
            
            //如果数据量过少，再删除底部刷新控件
            if(self.alreadySetupFooterRefreshControl){
                [self removeFooterRefreshControl];
            }
            
            //清空数据
            self.dataList=nil;
            [self reloadData];
            
            return;
        }
        
        //2.底部刷新没有数据
        if(CoreLTVCRequestTypeFooterRefresh == requestType){
            
            //底部刷新
            //底部刷新能够出现，说明列表是有至少一页的数据的，现在没有总是，最大的原因应该是下拉加载完了所有的数据
            //而且是刚好展示完pagesize的整数倍的数据，此时页面需要回退1
            _page--;
            [self.scrollView footerSetState:CoreFooterViewRefreshStateSuccessedResultNoMoreData];
            NSLog(@"底部刷新结束，没有更多数据了。");
            return;
        }
    }
    
    
    
    
    
    
    //字典数组转模型数组
    NSError *error=nil;
    NSArray *modelsArray=[_configModel.ModelClass objectArrayWithKeyValuesArray:dictsArray error:&error];
    
    if(error!=nil){
        NSLog(@"字典数组转模型数组时出现错误：%@",error.localizedDescription);return;
    }
    
    
    
    //模型数组校验
    BOOL res=[_configModel.ModelClass check:modelsArray];
    
    if(!res){
        NSLog(@"模型数组校验失败，请检查！");
        return;
    }
    
    NSArray *showArray=nil;
    
    //到这里，一定有数据

    
    //隐藏视图指示器
    [CoreViewNetWorkStausManager dismiss:self.view];
    
    //顶部刷新
    if(CoreLTVCRequestTypeHeaderRefresh == requestType){
        
        //检查顶部刷新的数据量是否
        /**
         *  安装底部刷新控件：根据数据安装底部刷新控件，一般来说，第一次加载数据才会执行此方法
         */
        if(!self.hasData){//如果还没有安装过底部刷新控件
            
            //如果数据量超过一屏才添加底部刷新控件
            CGFloat scrollViewH=self.scrollH;
            CGFloat dataListTotalH=_configModel.rowHeight * modelsArray.count;
            
            //安装底部刷新控件的条件
            //1.允许安装
            //2.还没有安装过
            //3.当前数据量足够超过scrollView的高度
            if(self.canSetupFooterRefreshControl && !self.alreadySetupFooterRefreshControl && dataListTotalH >=scrollViewH){
                [self addFooterRefreshControl];
            }
            
            //如果数据量过少，再删除底部刷新控件
            if(self.alreadySetupFooterRefreshControl && dataListTotalH <scrollViewH){
                [self removeFooterRefreshControl];
            }
        }
        
        
        
        //当前请求到的数据数组和记录的最新数据对比:
        if([CoreListCommonModel ListModel:modelsArray isEqual:self.headerRefreshDataListModelArray]){//无新数据
            
            //无新数据。不需要干扰底部刷新
            //页码恢复
            _page=_tempPage;
            
            //顶部刷新给出状态指示
            [self.scrollView headerSetState:CoreHeaderViewRefreshStateSuccessedResultNoMoreData];
            return;
            
        }else{//有新数据

            
            //状态指示
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scrollView headerSetState:CoreHeaderViewRefreshStateSuccessedResultDataShowing];
            });
            
            //有数据：顶部刷新后将要展示的数据
            showArray=modelsArray;
        }
        
        
    }
    
    //底部刷新
    if(CoreLTVCRequestTypeFooterRefresh == requestType){
        
        //数据直接叠加即可
        NSMutableArray *arrayM=[NSMutableArray arrayWithArray:self.dataList];
        [arrayM addObjectsFromArray:modelsArray];
        
        //状态指示
        [self.scrollView footerSetState:CoreFooterViewRefreshStateSuccessedResultDataShowing];
        
        //有数据：底部刷新后将要展示的数据
        showArray=arrayM;
    }
    
    //记录将要展示的数据
    self.dataList=showArray;

    //刷新数据
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}




/**
 *  添加底部刷新控件
 */
-(void)addFooterRefreshControl{
    
    //安装底部刷新控件
    [self.scrollView addFooterWithTarget:self action:@selector(footerRefreshAction)];
    
    //已经有了底部刷新控件
    self.alreadySetupFooterRefreshControl=YES;
}



/**
 *  移除底部刷新控件
 */
-(void)removeFooterRefreshControl{
    
    //由于业务的操作，数据量变少，需要执行底部刷新控件的移除
    [self.scrollView removeFooter];
    
    //已经没有了底部刷新控件
    self.alreadySetupFooterRefreshControl=NO;
}








/**
 *  处理失败
 */
-(void)error:(CoreHttpErrorType)errorType requestType:(CoreLTVCRequestType)requestType{
    
    //如果是下拉刷新，页面已经自增，但是数据没有回来，所以页码要回退
    if(CoreLTVCRequestTypeFooterRefresh == requestType) _page--;
    
    //界面指示(仅限网络错误)

    if(!_hasData){
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"网络错误" subMsg:@"当前网络出错，请点击屏幕重新加载。" offsetY:CoreViewNetWorkStausManagerOffsetY failClickBlock:^{
            
            //使用当前的请求方式，再次请求
            [self requestWithRequestType:requestType];

            //开始请求：如果初次就网络失败即没有成功安装底部刷新控件，则需要再次显示网络指示
            if(!_hasData){
                //添加一个网络指示器
                [CoreViewNetWorkStausManager show:self.view type:CMTypeLoadingWithImage msg:@"数据加载中" subMsg:@"请稍等，即将努力请求数据哦" offsetY:CoreViewNetWorkStausManagerOffsetY failClickBlock:nil];
            }
            
        }];
    }
    
    //刷新控件状态给出瓜
    if(CoreLTVCRequestTypeHeaderRefresh == requestType) [self.scrollView headerSetState:CoreHeaderViewRefreshStateRefreshingFailed];
    //刷新控件状态给出瓜
    if(CoreLTVCRequestTypeFooterRefresh == requestType) [self.scrollView footerSetState:CoreFooterViewRefreshStateFailed];

    //错误应该自行处理
    if(self.errorBlock!=nil) _errorBlock(errorType);
}



/**
 *  地址
 */
-(NSString *)url{
    
    if(_url==nil){
        
        //配置url
        NSString *urlStr=_configModel.url;
        
        NSRange range = [urlStr rangeOfString:@"?"];
        
        NSString *flag=(range.length==0)?@"?":@"&";
        
        _url=[NSString stringWithFormat:@"%@%@%@=%@&%@=",urlStr,flag,_configModel.pageSizeName,@(_configModel.pageSize),_configModel.pageName];
    }
    
    return _url;
}


-(void)setHasData:(BOOL)hasData{
    
    _hasData=hasData;
    
    //数据来了，隐藏指示视图
    [CoreViewNetWorkStausManager dismiss:self.view];
}


/**
 *  加载数据：等待子类实现此方法
 */
-(void)reloadData{


}


/**
 *  刷新获取最新数据：此方法会触发顶部刷新控件，并且scrollView会回到顶部
 */
-(void)reloadDataWithheaderViewStateRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scrollView headerSetState:CoreHeaderViewRefreshStateRefreshing];
    });
}


/**
 *  刷新获取最新数据：此方法不会触发顶部刷新控件，scrollView不会回到顶部
 */
-(void)reloadDataDerectly{
    
    [self requestWithRequestType:CoreLTVCRequestTypeHeaderRefresh];
}



-(BOOL)canSetupHeaderRefreshControl{
    BOOL res = (LTConfigModelRefreshControlTypeTopRefreshOnly == _configModel.refreshControlType || LTConfigModelRefreshControlTypeBoth == _configModel.refreshControlType);
    
    return res;
}

-(BOOL)canSetupFooterRefreshControl{
    return (LTConfigModelRefreshControlTypeBoth == _configModel.refreshControlType || LTConfigModelRefreshControlTypeBottomRefreshOnly == _configModel.refreshControlType);
}



-(CGFloat)scrollH{
    return self.scrollView.bounds.size.height;
}


-(void)setDataList:(NSArray *)dataList{
    
    _dataList=dataList;
    
    BOOL hasData=!(dataList==nil || dataList.count==0);
    
    //是否有数据
    self.hasData=hasData;
    
    if(CoreLTVCRequestTypeFooterRefresh == _currentType) return;
    
    //记录顶部服务器id数组
    self.headerRefreshDataListModelArray=hasData?dataList:nil;
}



/**
 *  scrollView代理方法区
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(_configModel.removeBackToTopBtn) return;
    
    CGFloat offsetY=scrollView.contentOffset.y;
    
    self.isHideBackTopBtn=offsetY<800;
}





-(UIButton *)backTopBtn{
    
    if(_backTopBtn==nil){

        UIButton *backTopBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [backTopBtn setImage:[UIImage imageNamed:@"CoreList.bundle/back_top"] forState:UIControlStateNormal];
        _backTopBtn=backTopBtn;
        backTopBtn.alpha=.5f;
        [backTopBtn addTarget:self action:@selector(backToTopAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backTopBtn];
        
        backTopBtn.translatesAutoresizingMaskIntoConstraints=NO;
        NSDictionary *views=NSDictionaryOfVariableBindings(backTopBtn);
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backTopBtn(==44)]-20-|" options:0 metrics:nil views:views]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backTopBtn(==44)]-80-|" options:0 metrics:nil views:views]];
    }
    
    return _backTopBtn;
}


-(void)backToTopAction{
    
    [self.scrollView setContentOffset:_oringinalOffset animated:YES];
}



-(void)setIsHideBackTopBtn:(BOOL)isHideBackTopBtn{
    
    if(_configModel.removeBackToTopBtn) return;
    
    if(_isHideBackTopBtn==isHideBackTopBtn) return;
    
    CGFloat alpha=isHideBackTopBtn?0.f:1.f;
    
    [UIView animateWithDuration:.25f animations:^{
        self.backTopBtn.alpha=alpha;
    }];
    
    _isHideBackTopBtn=isHideBackTopBtn;
}


-(void)dealloc{
    
    [self.scrollView removeFromSuperview];
    
    self.scrollView=nil;
}


@end
