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
- (NSArray<HistoryElement*>*) loadHistory;
@end
