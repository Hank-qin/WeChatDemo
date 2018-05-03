//
//  SendImageCollectionView.h
//  WeChat
//
//  Created by Xiaogang on 2018/5/1.
//  Copyright © 2018年 Xiaogang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XG_WeChatHeadCollectionReusableView.h"
@protocol XG_SendImageCollectionViewDelegate <NSObject>
-(void)needSelectSendImages;//从相册选择图片
@optional
-(void)needShowCurrentImageWithIndex:(NSIndexPath *)indexPath;//点击图片 显示大图预览
@end
@interface XG_SendImageCollectionView : UICollectionView
@property (nonatomic,strong) NSMutableArray *imagesMutableArr;
@property (nonatomic,weak) id <XG_SendImageCollectionViewDelegate>send_delegate;
/** 朋友圈 要发表的文字 */
@property (nonatomic,strong) XG_WeChatHeadCollectionReusableView *headerView;
/** 持有该View的Controller的self.view */
@property (nonatomic,weak) UIView *controller_view;
@end
