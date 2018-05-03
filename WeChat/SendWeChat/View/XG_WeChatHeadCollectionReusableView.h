//
//  XG_WeChatHeadCollectionReusableView.h
//  WeChat
//
//  Created by Hank-qin on 2018/5/2.
//  Copyright © 2018年 Xiaogang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XG_WeChatHeadCollectionReusableView : UICollectionReusableView<UITextViewDelegate>
/** 朋友圈 要发表的文字控件 */
@property (nonatomic,strong) UITextView *send_TextView;
@end
