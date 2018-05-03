//
//  SendMomentCollectionViewCell.m
//  TradeEhome_v3
//
//  Created by Hank-qin on 2018/4/17.
//  Copyright © 2018年 knrainy. All rights reserved.
//

#import "XG_SendMomentCollectionViewCell.h"

@implementation XG_SendMomentCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.send_imageView];
    }
    return self;
}
-(void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
-(UIImageView *)send_imageView{
    if(!_send_imageView){
        _send_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _send_imageView.clipsToBounds = YES;
        _send_imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _send_imageView;
}
@end
