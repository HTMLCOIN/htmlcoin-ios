//
//  DatabaseManager.h
//  qtum wallet
//
//  Created by Long Pham on 23/02/2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryElement;

@interface DatabaseManager : NSObject
+ (instancetype)sharedInstance;
+ (void) setUp;

- (void) storeTransactionHistory: (NSArray<HistoryElement*>*)transactions;
- (void) deleteTransactionHistory: (NSArray<HistoryElement*>*)transactions;
- (NSMutableArray<HistoryElement*>*) loadHistory;
- (void) clear;
-(BOOL) checkUnspentOutputWithTx: (NSString*) txId andAddress:(NSString*) addr;

// Balance
- (void)storeWalletInfo: (Wallet *)wallet;
- (Wallet* )loadWalletInfoForWallet: (Wallet*)wallet;
@end
