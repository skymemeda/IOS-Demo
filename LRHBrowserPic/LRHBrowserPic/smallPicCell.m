//
//  smallPicCell.m
//  LRHBrowserPic
//
//  Created by sks on 16/3/8.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "smallPicCell.h"
@interface smallPicCell()
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;

@end
@implementation smallPicCell

- (void)setPicImage:(UIImage *)picImage
{
    _picImage = picImage;
    self.picImageView.image = _picImage;
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
