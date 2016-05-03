//
//  LRHBroswer.m
//  LRHBrowserPic
//
//  Created by sks on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "LRHBroswer.h"
#import "PicCell.h"

#pragma LRHBSInfo Imp

@implementation LRHBSInfo
-(id)initInfoWithFrame:(CGRect)frame photoArray:(NSArray*)photoes picIndex:(NSInteger)index deleteBlock:(void(^)(id object,NSInteger index))deleteBlock cancelBlock:(void(^)(id object,NSInteger index))cancelBlock
{
    self=[super init];
    if(self)
    {
        self.frame = frame;
        self.photoes = photoes;
        self.currentPicIndex = index;
        self.delete_callback = deleteBlock;
        self.cancel_callback = cancelBlock;
    }
    return self;
}

@end


#pragma LRHPicView Declare

@interface LRHPicView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,PicCellDelegate>

@property( nonatomic, strong ) browser_action_block delete_callback;
@property( nonatomic, strong ) browser_action_block cancel_callback;

- (instancetype)initLRHPicViewWithFrame:(CGRect)frame WithImages:(NSArray*)images imageNames:(NSArray*)imageNames imageUrl:(NSArray*)urls atIndex:(NSInteger)index;
@end

#define KDeviceWidth     [[UIScreen mainScreen]bounds].size.width
#define KDeviceHight     [[UIScreen mainScreen]bounds].size.height
#define CellIdentifier    @"picCell"

#pragma LRHPicView Declare

typedef enum
{
    ButtonTypeCancel =100,
    ButtonTypeDelete
}ButtonType;
@implementation LRHPicView
{
    UICollectionView         *_collectionView;
    UILabel                  *_picIndexLabel;
    NSMutableArray           *_imageNameArray;
    NSMutableArray           *_imageArray;
    NSMutableArray           *_imageUrlArray;
    NSInteger                 _currentIndex;
}
- (instancetype)initLRHPicViewWithFrame:(CGRect)frame WithImages:(NSArray*)images imageNames:(NSArray*)imageNames imageUrl:(NSArray*)urls atIndex:(NSInteger)index
{
    if(self == [super initWithFrame:frame])
    {
        if(images!=nil)
        {
            _imageArray = [images mutableCopy];
        }
        if(imageNames!=nil)
        {
            _imageNameArray = [imageNames mutableCopy];
        }
        if(urls!=nil)
        {
            _imageUrlArray = [urls mutableCopy];
        }
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"PicCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
        [self addSubview:_collectionView];
        //下方图片索引
        _picIndexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,KDeviceHight-40, KDeviceWidth, 40)];
        _picIndexLabel.textAlignment = NSTextAlignmentCenter;
        _picIndexLabel.textColor = [UIColor whiteColor];
        _picIndexLabel.font = [UIFont systemFontOfSize:16];
        [self insertSubview:_picIndexLabel aboveSubview:_collectionView];
        //取消、删除
        for(int index = 0;index<2;index++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if(index == 0)
            {
                button.frame = CGRectMake(30, 80, 40, 30);
                [button setTitle:@"取消" forState:UIControlStateNormal];
            }
            else
            {
                button.frame = CGRectMake(KDeviceWidth-30-40, 80, 40, 30);
                [button setTitle:@"删除" forState:UIControlStateNormal];
            }
            button.tag = 100+index;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(buttonIsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self insertSubview:button aboveSubview:_collectionView];
        }
        if(index>0)//跳到当前显示的图片
        {
            _currentIndex = index;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
    return self;
}

- (void)buttonIsClicked:(UIButton*)button
{
    switch ( button.tag - 100 ) {
        case 0:
            {
               self.cancel_callback(button,_currentIndex);
            }
            break;
        case 1:
            {
                self.delete_callback(button,_currentIndex);
                if(_imageArray != nil)
                {
                    [_imageArray removeObjectAtIndex:_currentIndex];
                    if(_currentIndex>=_imageArray.count)
                    {
                        if(_imageArray.count == 0)
                        {
                            _currentIndex = 0;
                            [_collectionView reloadData];
                            _picIndexLabel.text = @"0/0";
                            return;
                        }
                        _currentIndex = _currentIndex-1;
                    }
                }
                if(_imageNameArray != nil)
                {
                    [_imageNameArray removeObjectAtIndex:_currentIndex];
                    if(_currentIndex>=_imageNameArray.count)
                    {
                        if(_imageNameArray.count == 0)
                        {
                            _currentIndex = 0;
                            [_collectionView reloadData];
                            _picIndexLabel.text = @"0/0";
                            return;
                        }
                        _currentIndex = _currentIndex-1;
                    }
                }
                [_collectionView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
                [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            }
            break;
        default:
            break;
    }
}
- (void)endBrowserPic
{
    [self removeFromSuperview];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(_imageArray!=nil)
    {
        return _imageArray.count;
    }
    if(_imageNameArray!=nil)
    {
        return _imageNameArray.count;
    }
    if(_imageUrlArray!=nil)
    {
        return _imageUrlArray.count;
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndex = indexPath.row;
    PicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PicCell" owner:self options:nil] lastObject];
    }
    [cell.scrollView setZoomScale:1];
    cell.delegate = self;
    UIImage *image = nil;
    if(_imageArray.count>0)
    {
        image = [_imageArray objectAtIndex:indexPath.row];
        _picIndexLabel.text = [NSString stringWithFormat:@"%ld/%lu",indexPath.row+1,(unsigned long)_imageArray.count];
    }
    else if(_imageNameArray.count>0)
    {
        image = [UIImage imageNamed:[_imageNameArray objectAtIndex:indexPath.row]];
        _picIndexLabel.text = [NSString stringWithFormat:@"%ld/%lu",indexPath.row+1,(unsigned long)_imageNameArray.count];
    }
    cell.picImage = image;
    return cell;
}

-  (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}
@end


#pragma LRHBrowser Imp
static LRHPicView         *_picView;
@implementation LRHBrowser
{
    
}

+ (void)showWithInfo:(LRHBSInfo*) info
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LRHPicView *picView = nil;
    if([info.photoes[0] isKindOfClass:[UIImage class]])
    {
        picView = [[LRHPicView alloc]initLRHPicViewWithFrame:info.frame WithImages:info.photoes imageNames:nil imageUrl:nil atIndex:info.currentPicIndex];
    }
    else if([info.photoes[0] isKindOfClass:[NSString class]])
    {
        picView = [[LRHPicView alloc]initLRHPicViewWithFrame:info.frame WithImages:nil imageNames:info.photoes imageUrl:nil atIndex:info.currentPicIndex];
    }
    picView.delete_callback = info.delete_callback;
    picView.cancel_callback = info.cancel_callback;
    _picView = picView;
    [window addSubview:picView];
}

+ (void)hideBrowser
{
    [_picView removeFromSuperview];
}
@end
