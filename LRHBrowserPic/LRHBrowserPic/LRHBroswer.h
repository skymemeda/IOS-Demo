//
//  LRHBroswer.h
//  LRHBrowserPic
//
//  Created by sks on 16/3/9.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^browser_action_block)( id object,NSInteger index);

@interface LRHBSInfo : NSObject

@property (nonatomic,assign) CGRect                     frame;
@property (nonatomic,strong) NSArray*                   photoes;//图片数组
@property (nonatomic,assign) NSInteger                  currentPicIndex;//当前显示图片index

//有删除 需要时 设置删除、取消回调，否则 无需设置
@property (nonatomic,strong) browser_action_block       delete_callback;
@property (nonatomic,strong) browser_action_block       cancel_callback;

-(id)initInfoWithFrame:(CGRect)frame photoArray:(NSArray*)photoes picIndex:(NSInteger)index deleteBlock:(void(^)(id object,NSInteger index))deleteBlock cancelBlock:(void(^)(id object,NSInteger index))cancelBlock;

@end


@interface LRHBrowser : NSObject
+ (void)showWithInfo:(LRHBSInfo*)info;
+ (void)hideBrowser;
@end
