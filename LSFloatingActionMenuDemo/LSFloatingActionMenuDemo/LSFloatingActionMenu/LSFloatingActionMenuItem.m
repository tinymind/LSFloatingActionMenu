//
//  LSFloatingActionMenuItem.m
//  LSFloatingActionMenuDemo
//
//  Created by lslin on 16/4/18.
//  Copyright © 2016年 lessfun.com. All rights reserved.
//

#import "LSFloatingActionMenuItem.h"

@interface LSFloatingActionMenuItem ()

@end

@implementation LSFloatingActionMenuItem

- (id)initWithImage:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage {
    if (self = [super init]) {
        self.image = image;
        self.highlightedImage = highlightedImage;
        self.itemSize = image.size;
        self.bounds = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
}

#pragma mark - Action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // if move out, cancel highlighted.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.bounds, location)) {
        self.highlighted = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    // if stop in the area, response to the touches event.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        if ([self.delegate respondsToSelector:@selector(floatingActionMenuItemDidTouch:)]) {
            [self.delegate floatingActionMenuItemDidTouch:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

@end
