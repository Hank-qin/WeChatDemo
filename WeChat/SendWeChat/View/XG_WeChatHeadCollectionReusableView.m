//
//  XG_WeChatHeadCollectionReusableView.m
//  WeChat
//
//  Created by Hank-qin on 2018/5/2.
//  Copyright © 2018年 Xiaogang. All rights reserved.
//

#import "XG_WeChatHeadCollectionReusableView.h"
static NSString *const XG_WeChatPlaceHoldString = @"这一刻的想法...";
@implementation XG_WeChatHeadCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.send_TextView];
        [_send_TextView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(10);
            make.bottom.right.equalTo(-10);
            
        }];
    }
    return self;
}
-(UITextView *)send_TextView{
    if(!_send_TextView){
        _send_TextView = [[UITextView alloc] init];
        _send_TextView.delegate = self;
        _send_TextView.font = [UIFont systemFontOfSize:14.f];
        _send_TextView.textColor = [UIColor lightGrayColor];
        _send_TextView.text = XG_WeChatPlaceHoldString;
    }
    return _send_TextView;
}
#pragma mark - textField delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:XG_WeChatPlaceHoldString] ) {
        textView.text = @"";
        textView.textColor = [UIColor grayColor];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (!textView.text || textView.text.length == 0 ) {
        textView.text = XG_WeChatPlaceHoldString;
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
@end
