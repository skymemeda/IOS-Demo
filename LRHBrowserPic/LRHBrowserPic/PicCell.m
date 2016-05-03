//
//  PicCell.m
//  LRHBrowserPic
//
//  Created by sks on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "PicCell.h"
@interface PicCell()
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@end
@implementation PicCell

- (void)awakeFromNib{
    self.scrollView.delegate = self;
    [self.scrollView setZoomScale:1];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endBrowserPic:)];
    [self.picImageView addGestureRecognizer:tapGesture];
}

- (void)endBrowserPic:(UITapGestureRecognizer*)gesture
{
    if([self.delegate respondsToSelector:@selector(endBrowserPic)])
    {
        [self.delegate endBrowserPic];
    }
//    UICollectionView *view = (UICollectionView*)[self superview];
//    [view removeFromSuperview];
    //view = nil;
}
- (void)setPicImage:(UIImage *)picImage
{
    _picImage = picImage;
    self.picImageView.image = _picImage;
    self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.picImageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self.scrollView setZoomScale:scale animated:YES];
}
@end
