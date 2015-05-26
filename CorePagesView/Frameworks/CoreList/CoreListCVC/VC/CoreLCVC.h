//
//  CoreCVC.h
//  CoreListMVC
//
//  Created by 沐汐 on 15-3-11.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreListVC.h"

@interface CoreLCVC : CoreListVC<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  collectionView
 */
@property (nonatomic,weak) UICollectionView *collectionView;


/**
 *  初始化方法
 */
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;


@end
