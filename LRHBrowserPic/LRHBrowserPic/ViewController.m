//
//  ViewController.m
//  LRHBrowserPic
//
//  Created by sks on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "ViewController.h"
#import "smallPicCell.h"
#include "LRHBroswer.h"
#define PicNumOfRow      4
#define PicWidth         70
#define PicHight         70
#define PicHorizalPadding       (KDeviceWidth-(PicNumOfRow*PicWidth))/(PicNumOfRow+1)
#define PicVerticaPadding (KDeviceWidth-(PicNumOfRow*PicWidth))/(PicNumOfRow+1)
#define PicCellIdentifier  @"smallPicCell"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView          *_collectionView;
    NSMutableArray            *_imageNameArray;//图片名字数组
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPicData];
    [self setCollectionView];
}

- (void)getPicData
{
    _imageNameArray = [[NSMutableArray alloc]init];
    for(int index =0;index<13;index++)
    {
        NSString *picName = [NSString stringWithFormat:@"image%d.jpg",index];
        [_imageNameArray addObject:picName];
    }
}
- (void)setCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"smallPicCell" bundle:nil]forCellWithReuseIdentifier:PicCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}
#pragma  UICollectionView  Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageNameArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    smallPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicCellIdentifier forIndexPath:indexPath];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"smallPicCell" owner:self options:nil] lastObject];
    }
    
    NSString *picName = [_imageNameArray objectAtIndex:indexPath.row];
    cell.picImage = [UIImage imageNamed:picName];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LRHBSInfo *info = [[LRHBSInfo alloc]initInfoWithFrame:self.view.frame photoArray:_imageNameArray picIndex:indexPath.row deleteBlock:^(id object, NSInteger index) {
          NSLog(@"delete");
      } cancelBlock:^(id object, NSInteger index) {
          NSLog(@"cancel");
      }];
    [LRHBrowser showWithInfo:info];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(PicWidth, PicHight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
