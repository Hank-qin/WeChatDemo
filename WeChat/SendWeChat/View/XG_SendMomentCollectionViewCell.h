//
//  SendMomentCollectionViewCell.h
//  TradeEhome_v3
//
//  Created by Hank-qin on 2018/4/17.
//  Copyright © 2018年 knrainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XG_SendMomentCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *send_imageView;
//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;
@end
