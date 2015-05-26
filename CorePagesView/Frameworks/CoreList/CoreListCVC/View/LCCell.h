//
//  CLCell.h
//  CoreListMVC
//
//  Created by 沐汐 on 15-3-11.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreListCommonModel.h"

@interface LCCell : UICollectionViewCell




/**
 *  模型数据
 */
@property (nonatomic,strong) CoreListCommonModel *model;



/**
 *  indexPath
 */
@property (nonatomic,strong) NSIndexPath *indexPath;



/**
 *  填充数据
 */
-(void)dataFill;














@end
