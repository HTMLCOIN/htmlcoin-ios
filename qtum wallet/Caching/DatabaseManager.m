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
#import "HistoryElementRealm.h"

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
    config.schemaVersion = 2;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // potentially lengthy data migration
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

-(void)storeTransactionHistory:(NSArray<HistoryElement *>*)transactions {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    for (HistoryElement *history in transactions) {
        HistoryElementRealm * historyRealm = [[HistoryElementRealm alloc] init];
        historyRealm.txHash = history.txHash;
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:historyRealm];
        }];
    }
    
}

- (NSArray<HistoryElement *> *)loadHistory {
    RLMResults<HistoryElementRealm *> *historyRealms = [HistoryElementRealm allObjects];
    
    NSMutableArray<HistoryElement*> * results = [NSMutableArray new];
    for (HistoryElementRealm * historyRealm in historyRealms) {
        HistoryElement *history = [HistoryElement new];
        history.txHash = historyRealm.txHash;
//        history.
//        self.dateNumber = ![object[@"blocktime"] isKindOfClass:[NSNull class]] ? object[@"blocktime"] : nil;
//        self.address = object[@"address"];
//        self.confirmed = [object[@"blockheight"] floatValue] > 0;
//        self.txHash = object[@"txid"];
//        self.isSmartContractCreater = [object[@"contract_has_been_created"] boolValue];
//        [self calcAmountAndAdresses:object];
        [results addObject:history];
    }
    
    return results;
}
@end
