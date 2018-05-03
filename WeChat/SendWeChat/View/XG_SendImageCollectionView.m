//
//  SendImageCollectionView.m
//  WeChat
//
//  Created by Xiaogang on 2018/5/1.
//  Copyright © 2018年 Xiaogang. All rights reserved.
//

#import "XG_SendImageCollectionView.h"
#import "XG_SendMomentCollectionViewCell.h"
static CGFloat const CellWidth = 70;
static int const MaxImagesCount = 9; //表示能够选择的最大图片数
static NSString *const XG_SendImageCellID = @"XG_SendImageCellID";
static NSString *const XG_WeChatHeadViewID = @"XG_WeChatCollectionHeadView";
@interface XG_SendImageCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>{
    NSIndexPath *_dragingIndexPath;//正在拖拽的indexpath
    NSIndexPath *_targetIndexPath;//目标位置
}
@property (nonatomic,strong) UIImageView *dragingCell;
@property (nonatomic,strong) UIButton *deleteButton;
@end

@implementation XG_SendImageCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CellWidth,CellWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, (mDeviceWidth - 70*4)/5, 10, (mDeviceWidth - 70*4)/5);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.headerReferenceSize = CGSizeMake(mDeviceWidth, 150);
    flowLayout.minimumInteritemSpacing = 0;
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}
-(void)initData{
    _imagesMutableArr = [NSMutableArray array];
}
-(void)initUI{
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[XG_SendMomentCollectionViewCell class] forCellWithReuseIdentifier:XG_SendImageCellID];
    [self registerClass:[XG_WeChatHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:XG_WeChatHeadViewID];
    self.dataSource = self;
    self.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.3f;
    [self addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGesture];
    
    
}
//关闭键盘
-(void)closeKeyBoard{
    [self endEditing:YES];
}
-(void)longPressMethod:(UILongPressGestureRecognizer*)gestureRecongnizer{
    CGPoint point = [gestureRecongnizer locationInView:self];
    switch (gestureRecongnizer.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChange:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd:point];
            break;
        default:
            break;
    }
}
#pragma mark -拖拽开始
-(void)dragBegin:(CGPoint)point{
    
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    XG_SendMomentCollectionViewCell *dragingCell = (XG_SendMomentCollectionViewCell*)[self cellForItemAtIndexPath:_dragingIndexPath];
    dragingCell.isMoving = YES;
    //更新被拖拽的item
    self.dragingCell.hidden = NO;
    _dragingCell.center = CGPointMake(point.x, point.y- self.contentOffset.y);
    _dragingCell.image = _imagesMutableArr[_dragingIndexPath.row];
    [_dragingCell setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
}
#pragma mark -正在被拖拽
-(void)dragChange:(CGPoint)point{
    if (_dragingIndexPath) {
        self.deleteButton.hidden = NO;
    }
    if (!_dragingIndexPath) {return;}
    _dragingCell.center = CGPointMake(point.x, point.y- self.contentOffset.y);;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    if (_dragingIndexPath) {
        if (CGRectContainsPoint(_deleteButton.frame, point)) {
            _deleteButton.selected = YES;
        }else{
            _deleteButton.selected = NO;
        }
    }
    //与目标cell交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        [self rankImageMutableArr];
        [self moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}
#pragma mark -更新Cell前 需先更新数据源
-(void)rankImageMutableArr
{
    id obj = [_imagesMutableArr objectAtIndex:_dragingIndexPath.row];
    [_imagesMutableArr removeObjectAtIndex:_dragingIndexPath.row];
    [_imagesMutableArr insertObject:obj atIndex:_targetIndexPath.row];
}
#pragma mark -拖拽结束
-(void)dragEnd:(CGPoint)point{
    _deleteButton.hidden = YES;
    if (!_dragingIndexPath) {return;}
    if (CGRectContainsPoint(_deleteButton.frame, point)) {
        _dragingCell.hidden = YES;
        _deleteButton.selected = NO;
        [_imagesMutableArr removeObjectAtIndex:_dragingIndexPath.row];
        [self reloadData];
        return;
    }
    CGRect endFrame = [self cellForItemAtIndexPath:_dragingIndexPath].frame;
    endFrame.origin.y -= self.contentOffset.y;//UIScrollView 及其子类都会相对父View发生偏移 
    [_dragingCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    
    XG_SendMomentCollectionViewCell *item = (XG_SendMomentCollectionViewCell*)[self cellForItemAtIndexPath:_dragingIndexPath];
    [UIView animateWithDuration:0.3 animations:^{
        self->_dragingCell.frame = endFrame;
    }completion:^(BOOL finished) {
        self.dragingCell.hidden = YES;
        item.isMoving = NO;
    }];
}
#pragma mark -获取被拖动的Cell的IndexPath
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)startPoint{
    NSIndexPath* dragIndexPath = nil;
    for (NSIndexPath *indexPath in self.indexPathsForVisibleItems) {
        //获取当前点所在的cell  且cell不能是添加图片按钮
        if (CGRectContainsPoint([self cellForItemAtIndexPath:indexPath].frame, startPoint)) {
            if (indexPath.row == _imagesMutableArr.count) {
                return nil;
            }else{
                dragIndexPath = indexPath;
                return dragIndexPath;
            }
        }
    }
    return dragIndexPath;
}

#pragma mark -获取目标Cell的IndexPath
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)movePoint{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in self.indexPathsForVisibleItems) {
        //获取目标点所在的cell  且cell不能是添加图片按钮 如果是起点cell 也没必要交换
        if ([indexPath isEqual:_dragingIndexPath]) {continue ;}
        if (CGRectContainsPoint([self cellForItemAtIndexPath:indexPath].frame, movePoint) && indexPath.row != _imagesMutableArr.count) {
            targetIndexPath = indexPath;
        }
    }
    return targetIndexPath;
}

#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:XG_WeChatHeadViewID forIndexPath:indexPath];
        return _headerView;
    }
    return nil;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imagesMutableArr.count < MaxImagesCount) {
        return _imagesMutableArr.count + 1;
    }else{
        return _imagesMutableArr.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XG_SendMomentCollectionViewCell* item = [collectionView dequeueReusableCellWithReuseIdentifier:XG_SendImageCellID forIndexPath:indexPath];
    item.send_imageView.layer.cornerRadius = 4.f;
    if (_imagesMutableArr.count < MaxImagesCount && indexPath.row == _imagesMutableArr.count) {
        item.send_imageView.image = [UIImage imageNamed:@"上传营业执照"];
    }else{
        item.send_imageView.image = [_imagesMutableArr[indexPath.row] imageWithRenderingMode:UIImageRenderingModeAutomatic] ;
    }
    return  item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_imagesMutableArr.count < MaxImagesCount && indexPath.row == _imagesMutableArr.count) {
        if (_send_delegate && [_send_delegate respondsToSelector:@selector(needSelectSendImages)]) {
            [_send_delegate needSelectSendImages];
        }
    }
}
#pragma mark -Lazy
-(UIImageView *)dragingCell{
    if(!_dragingCell){
        _dragingCell = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CellWidth, CellWidth)];
        _dragingCell.hidden = YES;
        _dragingCell.clipsToBounds = YES;
        _dragingCell.layer.cornerRadius = 4.f;
        _dragingCell.contentMode = UIViewContentModeScaleAspectFill;
        [_controller_view addSubview:_dragingCell];
    }
    return _dragingCell;
}
-(UIButton *)deleteButton{
    if(!_deleteButton){
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, self.frame.size.height - 50 - 64, mDeviceWidth, 50);
        [_deleteButton setTitle:@"拖动到此处删除" forState:UIControlStateNormal];
        [_deleteButton setTitle:@"松手即可删除" forState:UIControlStateSelected];
        [_deleteButton setBackgroundImage:[XG_CommonTool createImageWithColor:[UIColor blueColor] andSize:CGSizeMake(mDeviceWidth, 50)] forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:[XG_CommonTool createImageWithColor:[UIColor redColor] andSize:CGSizeMake(mDeviceWidth, 50)] forState:UIControlStateSelected];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _deleteButton.hidden = YES;
        [self addSubview:_deleteButton];
        _deleteButton.frame = CGRectMake(0, self.frame.size.height - 50 + self.contentOffset.y, self.frame.size.width, 50);
    }
    return _deleteButton;
}
@end
