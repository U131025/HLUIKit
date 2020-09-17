//
//  UIButton+UPImageTitleSpacing.h
//  UPPay
//
//  Created by mac on 2018/7/14.
//  Copyright © 2018年 YIJAYI. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, UPButtonEdgeInsetsStyle) {
    UPButtonEdgeInsetsStyleTop, // image在上，label在下
    UPButtonEdgeInsetsStyleLeft, // image在左，label在右
    UPButtonEdgeInsetsStyleBottom, // image在下，label在上
    UPButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (UPImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(UPButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
