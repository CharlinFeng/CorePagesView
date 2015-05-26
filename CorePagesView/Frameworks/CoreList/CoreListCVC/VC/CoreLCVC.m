//
//  CoreCVC.m
//  CoreListMVC
//
//  Created by 沐汐 on 15-3-11.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "CoreLCVC.h"
#import "LCCell.h"



@interface CoreLCVC ()

/**
 *  布局配置对象
 */
@property (nonatomic,strong) UICollectionViewLayout *layout;


@end





@implementation CoreLCVC


/**
 *  初始化方法
 */
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    
    self=[super init];
    
    if(self){
        
        self.layout=layout;
    }
    
    return self;
}






/**
 *  重新加载数据
 */
-(void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



/**
 *  有多少组
 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



/**
 *  共有多少行
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}




/**
 *  cell
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *rid=NSStringFromClass(self.configModel.ViewForCellClass);
    
    LCCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:rid forIndexPath:indexPath];
    
    cell.model=self.dataList[indexPath.item];
    
    return cell;
}





/**
 *  collectionView
 */
-(UICollectionView *)collectionView{
    
    if(_collectionView==nil){
        UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _collectionView=collectionView;
        collectionView.delegate=self;
        collectionView.dataSource=self;
        [self.view addSubview:collectionView];
        
        collectionView.translatesAutoresizingMaskIntoConstraints=NO;
        NSDictionary *views=NSDictionaryOfVariableBindings(collectionView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:nil views:views]];
    }
    
    return _collectionView;
}



/**
 *  scrollView
 */
-(UIScrollView *)scrollView{
    return self.collectionView;
}



@end
