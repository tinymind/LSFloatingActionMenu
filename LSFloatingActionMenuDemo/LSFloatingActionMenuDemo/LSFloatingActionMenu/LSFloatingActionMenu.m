//
//  LSFloatingActionMenu.m
//  LSFloatingActionMenuDemo
//
//  Created by lslin on 16/4/18.
//  Copyright © 2016年 lessfun.com. All rights reserved.
//

#import "LSFloatingActionMenu.h"

static const CGFloat kLSAnimationDurationStartMenuRotate = 0.25;
static const CGFloat kLSAnimationDelay = 0.036f;
static const CGFloat kLSAnimationDuration = 0.3f;
static NSString * const kLSKeyAnimationGroupID = @"AnimationGroupID";
static NSString * const kLSKeyFirstAnimationGroupValue = @"FirstAnimationGroup";
static NSString * const kLSKeyLastAnimationGroupValue = @"LastAnimationGroup";

@interface LSFloatingActionMenu () <LSFloatingActionMenuItemDelegate>

@property (nonatomic, assign) LSFloatingActionMenuDirection direction;
@property (nonatomic, copy) NSArray *menuItems;
@property (nonatomic, copy) void (^menuHandler)(LSFloatingActionMenuItem *item, NSUInteger index);
@property (nonatomic, copy) void (^closeHandler)(void);

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSInteger animationTag;
@end

@implementation LSFloatingActionMenu

- (id)initWithFrame:(CGRect)frame
          direction:(LSFloatingActionMenuDirection)direction
          menuItems:(NSArray *)menuItems
        menuHandler:(void (^)(LSFloatingActionMenuItem *item, NSUInteger index))menuHandler
       closeHandler:(void (^)(void))closeHandler {
    
    if (self = [super initWithFrame:frame]) {
        self.direction = direction;
        self.menuItems = menuItems;
        self.menuHandler = menuHandler;
        self.closeHandler = closeHandler;
        self.startPoint = CGPointMake(20, 240);
        self.itemSpacing = 10;
    }
    return self;
}

- (LSFloatingActionMenuItem *)menuItemAtIndex:(NSUInteger)index {
    if (index < self.menuItems.count) {
        return self.menuItems[index];
    }
    return nil;
}

- (void)open {
    if (self.isAnimating || self.isExpanded) {
        return;
    }
    [self animateWithExpand:YES];
}

- (void)close {
    if (self.isAnimating || !self.isExpanded) {
        return;
    }
    [self animateWithExpand:NO];
}

#pragma mark - Touch

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // if the menu is animating, prevent touches
    if (self.isAnimating) {
        return NO;
    }
    // if the menu state is expanding, everywhere can be touch
    // otherwise, only the add button are can be touch
    if (self.isExpanded) {
        return YES;
    } else {
        return CGRectContainsPoint([[self menuItemAtIndex:0] frame], point);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self close];
}

#pragma mark - FloatingActionMenuItemDelegate

- (void)floatingActionMenuItemDidTouch:(LSFloatingActionMenuItem *)item {
    if (item.tag == 0) {
        [self close];
        return;
    }
    
    [self animateWithExpand:NO];
    if (self.menuHandler) {
        self.menuHandler(item, item.tag);
    }
}

#pragma mark - Private

- (void)animateWithExpand:(BOOL)expand {
    if (expand) {
        [self setupMenu];
    }
    
    self.isExpanded = expand;
    
    [self rotateStartButtonIfNeed];
    
    // expand or close animation
    if (!self.animationTimer) {
        self.animationTag = expand ? 0 : self.menuItems.count;
        SEL selector = expand ? @selector(doExpandAnimation) : @selector(doCloseAnimation);
        
        // Adding timer to runloop to make sure UI event won't block the timer from firing
        self.animationTimer = [NSTimer timerWithTimeInterval:kLSAnimationDelay target:self selector:selector userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
        self.isAnimating = YES;
        [self.animationTimer fire];
    }
}

- (void)setupMenu {
    LSFloatingActionMenuItem *startMenu = nil;
    CGFloat yOffset = 0;
    CGFloat xOffset = 0;
    for (int i = 0; i < [self.menuItems count]; i ++) {
        LSFloatingActionMenuItem *item = [self.menuItems objectAtIndex:i];
        item.tag = i;
        item.delegate = self;
        item.startPoint = self.startPoint;
        item.center = item.startPoint;
        
        switch (self.direction) {
            case LSFloatingActionMenuDirectionUp: {
                yOffset = item.startPoint.y - i * (item.itemSize.height + self.itemSpacing);
                item.endPoint = CGPointMake(self.startPoint.x, yOffset);
                item.nearPoint = CGPointMake(self.startPoint.x, yOffset + self.itemSpacing);
                item.farPoint = CGPointMake(self.startPoint.x, yOffset - self.itemSpacing);
                break;
            }
            case LSFloatingActionMenuDirectionDown: {
                yOffset = item.startPoint.y + i * (item.itemSize.height + self.itemSpacing);
                item.endPoint = CGPointMake(self.startPoint.x, yOffset);
                item.nearPoint = CGPointMake(self.startPoint.x, yOffset - self.itemSpacing);
                item.farPoint = CGPointMake(self.startPoint.x, yOffset + self.itemSpacing);
                break;
            }
            case LSFloatingActionMenuDirectionLeft: {
                xOffset = item.startPoint.x + i * (item.itemSize.width + self.itemSpacing);
                item.endPoint = CGPointMake(xOffset, self.startPoint.y);
                item.nearPoint = CGPointMake(xOffset - self.itemSpacing, self.startPoint.y);
                item.farPoint = CGPointMake(xOffset + self.itemSpacing, self.startPoint.y);
                break;
            }
            case LSFloatingActionMenuDirectionRight: {
                xOffset = item.startPoint.x - i * (item.itemSize.width + self.itemSpacing);
                item.endPoint = CGPointMake(xOffset, self.startPoint.y);
                item.nearPoint = CGPointMake(xOffset + self.itemSpacing, self.startPoint.y);
                item.farPoint = CGPointMake(xOffset - self.itemSpacing, self.startPoint.y);
                break;
            }
            default:
                break;
        }
        
        if (i == 0) {
            item.endPoint = item.startPoint;
            item.nearPoint = item.startPoint;
            item.farPoint = item.startPoint;
            
            [self addSubview:item];
            startMenu = item;
        } else {
            [self insertSubview:item belowSubview:startMenu];
        }
    }
}

- (void)rotateStartButtonIfNeed {
    if (!self.rotateStartMenu) {
        return;
    }
    float angle = self.isExpanded ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:kLSAnimationDurationStartMenuRotate animations:^{
        [self menuItemAtIndex:0].transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (void)doExpandAnimation {
    if (self.animationTag == [self.menuItems count]) {
        self.isAnimating = NO;
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        return;
    }
    
    LSFloatingActionMenuItem *item = [self menuItemAtIndex:self.animationTag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = kLSAnimationDuration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = kLSAnimationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    if(self.animationTag == [self.menuItems count] - 1){
        [animationgroup setValue:kLSKeyFirstAnimationGroupValue forKey:kLSKeyAnimationGroupID];
    }
    
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    ++ self.animationTag;
}

- (void)doCloseAnimation {
    if (self.animationTag == 0) {
        self.isAnimating = NO;
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        return;
    }
    
    LSFloatingActionMenuItem *item = [self menuItemAtIndex:self.animationTag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = kLSAnimationDuration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = kLSAnimationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    if(self.animationTag == 1){
        [animationgroup setValue:kLSKeyLastAnimationGroupValue forKey:kLSKeyAnimationGroupID];
    }
    
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    
    -- self.animationTag;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if([[animation valueForKey:kLSKeyAnimationGroupID] isEqual:kLSKeyLastAnimationGroupValue]) {
        if (self.closeHandler) {
            self.closeHandler();
        }
    } else if([[animation valueForKey:kLSKeyAnimationGroupID] isEqual:kLSKeyFirstAnimationGroupValue]) {
        
    }
}

@end
