//
//  BorderedLabel.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorderedLabel : UILabel

@property (nonatomic, readonly) UIView *borderView;

- (UIColor *)getBorderColor;

@end
