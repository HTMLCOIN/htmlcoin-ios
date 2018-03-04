//
//  LoginViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "LoginViewControllerDark.h"

@interface LoginViewControllerDark ()

@end

@implementation LoginViewControllerDark

-(void)configPasswordView {
    
    [self.passwordView setStyle:LightStyle lenght:[AppSettings sharedInstance].isLongPin ? LongType : ShortType];
    self.passwordView.delegate = self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
