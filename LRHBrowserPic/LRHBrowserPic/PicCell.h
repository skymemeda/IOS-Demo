//
//  PicCell.h
//  LRHBrowserPic
//
//  Created by sks on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PicCellDelegate<NSObject>
@optional
- (void)endBrowserPic;
@end
@interface PicCell : UICollectionViewCell<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong)UIImage     *picImage;
@property (nonatomic,weak)id<PicCellDelegate>delegate;
@end
