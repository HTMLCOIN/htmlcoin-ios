//
//  AppSettings.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AppSettings.h"
#import "NSUserDefaults+Settings.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "LanguageManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TouchIDService.h"
#import "PaymentValuesManager.h"

@interface AppSettings ()

@property (assign, nonatomic) BOOL isMainNet;
@property (assign, nonatomic) BOOL isRPC;
@property (assign, nonatomic) BOOL isDarkTheme;
@property (assign, nonatomic) BOOL isRemovingContractTrainingPassed;
@property (assign, nonatomic) NSInteger failedPinWaitingTime;

@end

@implementation AppSettings

#pragma mark - init

+ (instancetype)sharedInstance {
    
    static AppSettings *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    return self;
}

#pragma mark - Public Methods

-(void)setup {
    
    if (![NSUserDefaults isNotFirstTimeLaunch]) {
        [NSUserDefaults saveIsDarkSchemeSetting:NO];
        [NSUserDefaults saveIsNotFirstTimeLaunch:NO];
    }
    
    [NSUserDefaults saveCurrentVersion:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
    [NSUserDefaults saveIsRPCOnSetting:NO];
    
#if PRODUCTION
    [NSUserDefaults saveIsMainnetSetting:YES];
#else
    [NSUserDefaults saveIsMainnetSetting:NO];
#endif

    [PopUpsManager sharedInstance];
    [PaymentValuesManager sharedInstance];
    [self setupFabric];
    [self setupFingerpring];
}

-(void)setupFabric{
    [Fabric with:@[[Crashlytics class]]];
}

-(void)setupFingerpring {
    
    if( [[TouchIDService sharedInstance] hasTouchId]) {
        [NSUserDefaults saveIsFingerpringAllowed:YES];
    } else {
        [NSUserDefaults saveIsFingerpringAllowed:NO];
    }
}

-(void)changeThemeToDark:(BOOL) needDarkTheme {
    [NSUserDefaults saveIsDarkSchemeSetting:needDarkTheme];
}

-(void)changeIsRemovingContractTrainingPassed:(BOOL) passed {
    [NSUserDefaults saveIsRemovingContractTrainingPassed:passed];
}

#pragma mark - Accessory methods

-(BOOL)isMainNet{
    return [NSUserDefaults isMainnetSetting];
}

-(BOOL)isRPC{
    return [NSUserDefaults isRPCOnSetting];
}

-(BOOL)isDarkTheme{
    return [NSUserDefaults isDarkSchemeSetting];
}

-(BOOL)isFingerprintEnabled{
    return [NSUserDefaults isFingerprintAllowed] && [NSUserDefaults isFingerprintEnabled];
}

-(BOOL)isFingerprintAllowed{
    return [NSUserDefaults isFingerprintAllowed];
}

-(BOOL)isLongPin {
    
    return [ApplicationCoordinator sharedInstance].walletManager.isLongPin;
}

-(BOOL)isRemovingContractTrainingPassed {
    
    return [NSUserDefaults isRemovingContractTrainingPassed];
}

-(NSString*)baseURL {
    
#ifdef PRODUCTION
    return @"http://api.htmlcoin.com";
#elif STAGING
    return @"http://35.198.235.246:3001";
#else
    // TODO: We don't support DEV currently.
    return @"http://35.198.235.246:3001";
#endif
//    NSString* baseUrl = @"http://api.htmlcoin.com";
//    return baseUrl;
}

-(NSInteger)failedPinWaitingTime {
    return 10;
}

#pragma mark - Private Methods 

-(void)setFingerprintEnabled:(BOOL)enabled {
    [NSUserDefaults saveIsFingerpringEnabled:enabled];
}

#pragma mark - Clearable

-(void)clear {
    
    [NSUserDefaults saveLastFailedPinDate:nil];
    [NSUserDefaults saveFailedPinCount:0];
}


@end
