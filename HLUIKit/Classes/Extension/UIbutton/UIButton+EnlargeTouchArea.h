//
//  UIButton+EnlargeTouchArea.h
//  sixin
//
//  Created by luo.h on 14-11-29.
//  Copyright (c) 2014年 sibu.cn. All rights reserved.
//
/**
 @  UIButton    Category
 @param
 @param  增加按钮点击范围
 
 // 增加 button 的点击范围
 [enlargeButton setEnlargeEdgeWithTop:20 right:20 bottom:20
 left:0];
 */




#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
- (CGRect) enlargedRect;
- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event;

@end
