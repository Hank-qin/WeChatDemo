//
//  SendWechatViewController.m
//  WeChat
//
//  Created by Xiaogang on 2018/5/1.
//  Copyright © 2018年 Xiaogang. All rights reserved.
//

#import "XG_SendWechatViewController.h"
#import "XG_SendImageCollectionView.h"
#import "QBImagePickerController.h"

static int const MaxImagesCount = 9; //表示能够选择的最大图片数
@interface XG_SendWechatViewController ()<QBImagePickerControllerDelegate,XG_SendImageCollectionViewDelegate>
@property (nonatomic,strong) XG_SendImageCollectionView *collectionView;
@end

@implementation XG_SendWechatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发表朋友圈";
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonlick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonlick)];
    
    [self.view addSubview:self.collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.safeAreaInsets);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}
-(void)cancelButtonlick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendButtonlick{
    
}
#pragma mark -XG_SendImageCollectionViewDelegate
-(void)needSelectSendImages{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
    imagePickerController.maximumNumberOfSelection = MaxImagesCount - (int)_collectionView.imagesMutableArr.count;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}
-(void)needShowCurrentImageWithIndex:(NSIndexPath *)indexPath{
    
}
#pragma mark -
#pragma mark - QBImagePickerControllerDelegate  选择图片库
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSMutableArray *tepArray = [[NSMutableArray alloc] init];
    for (ALAsset *asset in assets) {
        // Do something with the asset
        UIImage *assetImage = [self fullResolutionImageFromALAsset:asset];
        [tepArray addObject:assetImage];
    }
    [self.collectionView.imagesMutableArr addObjectsFromArray:tepArray];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}
#pragma mark -Lazy
-(XG_SendImageCollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[XG_SendImageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.send_delegate = self;
        _collectionView.controller_view = self.view;
    }
    return _collectionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
