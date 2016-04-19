# LSFloatingActionMenu
LSFloatingActionMenu is floating action button component of material design for iOS. 

## ScreenShot

![LSFloatingActionMenu](https://raw.githubusercontent.com/tinymind/LSFloatingActionMenu/master/LSFloatingActionMenuExample.gif)

## Installation

### Add source code to project

Add [LSFloatingActionMenu](https://github.com/tinymind/LSFloatingActionMenu/tree/master/LSFloatingActionMenuDemo/LSFloatingActionMenuDemo/LSFloatingActionMenu) to your XCode project.

### CocoaPods

Coming Soon...

## Usage

``` objc
#import "LSFloatingActionMenu.h"

- (IBAction)onTopLeftButtonClicked:(UIButton *)sender {
    [self showMenuFromButton:sender withDirection:LSFloatingActionMenuDirectionUp];
}

- (void)showMenuFromButton:(UIButton *)button withDirection:(LSFloatingActionMenuDirection)direction {
    button.hidden = YES;
    
    NSArray *menuIcons = @[@"icon_menu_add", @"icon_menu_unlock", @"icon_menu_kick", @"icon_menu_user", @"icon_menu_mic", @"icon_menu_lock"];
    NSMutableArray *menus = [NSMutableArray array];
    
    CGSize itemSize = button.frame.size;
    for (NSString *icon in menuIcons) {
        LSFloatingActionMenuItem *item = [[LSFloatingActionMenuItem alloc] initWithImage:[UIImage imageNamed:icon] highlightedImage:[UIImage imageNamed:[icon stringByAppendingString:@"_highlighted"]]];
        item.itemSize = itemSize;
        [menus addObject:item];
    }
    
    self.actionMenu = [[LSFloatingActionMenu alloc] initWithFrame:self.view.bounds direction:direction menuItems:menus menuHandler:^(LSFloatingActionMenuItem *item, NSUInteger index) {
            //TODO
    } closeHandler:^{
        [self.actionMenu removeFromSuperview];
        self.actionMenu = nil;
        button.hidden = NO;
    }];
    
    self.actionMenu.itemSpacing = 12;
    self.actionMenu.startPoint = button.center;
    
    [self.view addSubview:self.actionMenu];
    [self.actionMenu open];
}

```
