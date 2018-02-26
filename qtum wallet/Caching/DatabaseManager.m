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
        historyRealm.amount = history.amount;
        historyRealm.dateNumber = history.dateNumber;
        historyRealm.confirmed = history.confirmed;
        historyRealm.isSmartContractCreater = history.isSmartContractCreater;
        historyRealm.address = history.address;
        historyRealm.send = history.send;
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:historyRealm];
        }];
    }
    
}

-(void)deleteTransactionHistory:(NSArray<HistoryElement *> *)transactions {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSMutableArray<NSString*> * txHashPredicates = [NSMutableArray new];
    for (HistoryElement *history in transactions) {
        [txHashPredicates addObject:[NSString stringWithFormat:@"txHash == %@", history.txHash]];
    }
    
    RLMResults<HistoryElementRealm *> *historyRealms = [HistoryElementRealm objectsWhere:txHashPredicates];
    [realm deleteObjects:historyRealms];
}

- (NSMutableArray<HistoryElement *> *)loadHistory {
    RLMResults<HistoryElementRealm *> *historyRealms = [HistoryElementRealm allObjects];
    
    NSMutableArray<HistoryElement*> * results = [NSMutableArray new];
    for (HistoryElementRealm * historyRealm in historyRealms) {
        HistoryElement *history = [HistoryElement new];
        history.txHash = historyRealm.txHash;
        history.amount = historyRealm.amount;
        history.dateNumber = historyRealm.dateNumber;
        history.address = historyRealm.address;
        history.send = historyRealm.send;
        history.isSmartContractCreater = historyRealm.isSmartContractCreater;
        history.confirmed = historyRealm.confirmed;
        [results addObject:history];
    }
    
    return results;
}

-(void)clear {
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm deleteAllObjects];
}
@end
