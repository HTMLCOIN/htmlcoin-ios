//
//  LoginCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LoginMode){
    StartFirstSession,
    StartNewSession
};

typedef NS_ENUM(NSInteger, SecurityType){
    SecurityController,
    SecurityPopup,
};

@protocol ApplicationCoordinatorDelegate;

@interface LoginCoordinator : BaseCoordinator <Coordinatorable>

@property (weak, nonatomic) id <ApplicationCoordinatorDelegate> delegate;
@property (assign, nonatomic) LoginMode mode;
@property (assign, nonatomic) SecurityType type;

- (instancetype)initWithParentViewContainer:(UIViewController*) containerViewController;

@end
