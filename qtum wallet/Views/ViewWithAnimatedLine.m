//
//  ViewWithAnimatedLine.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ViewWithAnimatedLine.h"

@interface ViewWithAnimatedLine()

@property (nonatomic, weak) NSLayoutConstraint *trailingConstraintForLine;

@end

@implementation ViewWithAnimatedLine

- (void)showAnimation{
    self.trailingConstraintForLine.constant = self.frame.size.width;
    [self layoutIfNeeded];

    self.trailingConstraintForLine.constant = 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)setRightConstraint:(NSLayoutConstraint *)constraint{
    self.trailingConstraintForLine = constraint;
}

@end