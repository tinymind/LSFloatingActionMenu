//
//  ViewController.m
//  LSFloatingActionMenuDemo
//
//  Created by lslin on 16/4/18.
//  Copyright © 2016年 lessfun.com. All rights reserved.
//

#import "ViewController.h"
#import "LSFloatingActionMenu.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *topLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *topRightButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightButton;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (strong, nonatomic) LSFloatingActionMenu *actionMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)onTopLeftButtonClicked:(UIButton *)sender {
    [self showMenuFromButton:sender withDirection:LSFloatingActionMenuDirectionLeft];
}

- (IBAction)onTopRightButtonClicked:(UIButton *)sender {
    [self showMenuFromButton:sender withDirection:LSFloatingActionMenuDirectionDown];
}

- (IBAction)onBottomLeftButtonClicked:(UIButton *)sender {
    [self showMenuFromButton:sender withDirection:LSFloatingActionMenuDirectionUp];
}

- (IBAction)onBottomRightButtonClicked:(UIButton *)sender {
    [self showMenuFromButton:sender withDirection:LSFloatingActionMenuDirectionRight];
}

#pragma mark - Private

- (void)showMenuFromButton:(UIButton *)button withDirection:(LSFloatingActionMenuDirection)direction {
    button.hidden = YES;
    self.tipsLabel.text = @"";
    
    NSArray *menuIcons = @[@"icon_menu_add", @"icon_menu_unlock", @"icon_menu_kick", @"icon_menu_user", @"icon_menu_mic", @"icon_menu_lock"];
    NSMutableArray *menus = [NSMutableArray array];
    
    CGSize itemSize = button.frame.size;
    for (NSString *icon in menuIcons) {
        LSFloatingActionMenuItem *item = [[LSFloatingActionMenuItem alloc] initWithImage:[UIImage imageNamed:icon] highlightedImage:[UIImage imageNamed:[icon stringByAppendingString:@"_highlighted"]]];
        item.itemSize = itemSize;
        [menus addObject:item];
    }
    
    self.actionMenu = [[LSFloatingActionMenu alloc] initWithFrame:self.view.bounds direction:direction menuItems:menus menuHandler:^(LSFloatingActionMenuItem *item, NSUInteger index) {
            self.tipsLabel.text = [NSString stringWithFormat:@"Click at index %d", (int)index];
    } closeHandler:^{
        [self.actionMenu removeFromSuperview];
        self.actionMenu = nil;
        button.hidden = NO;
    }];
    
    self.actionMenu.itemSpacing = 12;
    self.actionMenu.startPoint = button.center;
    if (button == self.bottomLeftButton || button == self.topRightButton) {
        self.actionMenu.rotateStartMenu = YES;
    }
    
    [self.view addSubview:self.actionMenu];
    [self.actionMenu open];
}

@end
