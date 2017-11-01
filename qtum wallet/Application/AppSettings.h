//
//  AppSettings.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject <Clearable>

@property (assign, nonatomic, readonly) BOOL isMainNet;
@property (assign, nonatomic, readonly) BOOL isRPC;
@property (assign, nonatomic, readonly) BOOL isFingerprintEnabled;
@property (assign, nonatomic, readonly) BOOL isFingerprintAllowed;
@property (assign, nonatomic, readonly) BOOL isLongPin;
@property (assign, nonatomic, readonly) BOOL isDarkTheme;
@property (assign, nonatomic, readonly) NSInteger failedPinWaitingTime;
@property (copy, nonatomic, readonly) NSString* baseURL;


-(void)setup;
-(void)setFingerprintEnabled:(BOOL)enabled;
-(void)changeThemeToDark:(BOOL) needDarkTheme;
-(void)changeIsRemovingContractTrainingPassed:(BOOL) passed;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
