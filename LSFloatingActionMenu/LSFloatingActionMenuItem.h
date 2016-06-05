//
//  LSFloatingActionMenuItem.h
//  LSFloatingActionMenuDemo
//
//  Created by lslin on 16/4/18.
//  Copyright © 2016年 lessfun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSFloatingActionMenuItem;

@protocol LSFloatingActionMenuItemDelegate <NSObject>

@required
- (void)floatingActionMenuItemDidTouch:(LSFloatingActionMenuItem *)item;

@end

@interface LSFloatingActionMenuItem : UIImageView

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;
@property (nonatomic) CGSize itemSize;/**< Default is image size */

@property (nonatomic, weak) id<LSFloatingActionMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage;

@end
