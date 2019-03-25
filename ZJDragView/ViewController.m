//
//  ViewController.m
//  ZJDragView
//
//  Created by mac on 3/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "ZJDragView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ViewController ()

@property(nonatomic,copy)ZJDragView * zjDragView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.zjDragView];
}

-(ZJDragView *)zjDragView{
    if (!_zjDragView) {
        _zjDragView = [[ZJDragView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 120) titleArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    }
    return _zjDragView;
}

@end
