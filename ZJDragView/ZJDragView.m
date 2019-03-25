//
//  HomeMineCategoryView.m
//  SYEdu
//
//  Created by mac on 3/21/19.
//  Copyright © 2019 qhths. All rights reserved.
//

#import "ZJDragView.h"
#define Button_Tag 10
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ZJDragView ()
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
    NSInteger _index;
}

@property(nonatomic,copy)NSArray * titleArray;

@property (strong , nonatomic) NSMutableArray *itemArray;

@end

@implementation ZJDragView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray{
    if (self == [super initWithFrame:frame]) {
        self.titleArray = titleArray;
        [self addUI];
    }
    return self;
}

-(void)addUI{
    CGFloat Btn_Width = SCREEN_WIDTH/4;
    CGFloat Btn_Height = 20;
    CGFloat Padding = 10;
    for (int i=0; i<self.titleArray.count; i++) {
        NSInteger rowNum = i/4;
        NSInteger colNum = i%4;
        
        CGFloat imageX = colNum * Btn_Width;
        CGFloat imageY =rowNum * (Btn_Height + Padding);
        UIButton * button = [[UIButton alloc]init];
        button.frame = CGRectMake(imageX, imageY, Btn_Width, Btn_Height);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag =Button_Tag + i;
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [button addGestureRecognizer:longGesture];
        [self.itemArray addObject:button];
        [self addSubview:button];
    }
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    NSInteger from = 0;
    NSInteger to =0;
    UIButton *btn = (UIButton *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan){
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        _index = [self.itemArray indexOfObject:btn];
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0){
            contain = NO;
        }
        else
        {
            from =_index;
            to = index;
            if (from < to) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint temp =CGPointZero;
                    for (NSInteger i = from; i<to; i++) {
                        UIButton * button = self.itemArray[i+1];
                        temp = button.center;
                        button.center = self->originPoint;
                        self->originPoint = temp;
                    }
                    [self changeArrayDataSourceWithfrom:from to:to];
                    btn.center = temp;
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint temp =CGPointZero;
                    for (NSInteger i =from; i>to; i--) {
                        UIButton * button = self.itemArray[i-1];
                        temp = button.center;
                        button.center = self->originPoint;
                        self->originPoint = temp;
                    }
                    [self changeArrayDataSourceWithto:to from:from];
                    btn.center = temp;
                }];
            }
            self->contain = YES;
        }
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!self->contain)
            {
                btn.center = self->originPoint;
            }
        }];
    }
}

-(void)changeArrayDataSourceWithfrom:(NSInteger)from to:(NSInteger)to{
    id temp = [self.itemArray objectAtIndex:from];
    for(NSInteger i=from;i<to;i++){
        self.itemArray[i] = self.itemArray[i+1];
        if (i+1 == to) {
            self.itemArray[i+1] = temp;
        }
    }
    _index = to;
    for (UIButton * button in self.itemArray) {
        NSLog(@"%@",button.titleLabel.text);
    }
}

-(void)changeArrayDataSourceWithto:(NSInteger)to from:(NSInteger)from{
    id temp = [self.itemArray objectAtIndex:from];
    for(NSInteger i=from;i>to;i--){
        self.itemArray[i] = self.itemArray[i-1];
        if (i-1 == to) {
            self.itemArray[i-1] = temp;
        }
    }
    _index = to;
    for (UIButton * button in self.itemArray) {
        NSLog(@"%@",button.titleLabel.text);
    }
}

- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<self.itemArray.count;i++)
    {
        UIButton *button = self.itemArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

-(NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc]init];
    }
    return _itemArray;
}

@end
