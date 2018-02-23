//
//  DatabaseManager.m
//  qtum wallet
//
//  Created by Long Pham on 23/02/2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "DatabaseManager.h"
#import <Realm/Realm.h>
#import "HistoryElement.h"

@implementation DatabaseManager

+ (instancetype)sharedInstance {
    
    static DatabaseManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

+(void) setUp {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // potentially lengthy data migration
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

-(void)storeTransactionHistory:(NSArray<HistoryElement *>*)transactions {
    for (HistoryElement *history in transactions) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:history];
        }];
    }
}
@end
