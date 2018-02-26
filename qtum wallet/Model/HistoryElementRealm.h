//
//  HistoryElementRealm.h
//  qtum wallet
//
//  Created by Long Pham on 23/02/2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "HistoryElementValueRealm.h"

@interface HistoryElementRealm : RLMObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSNumber<RLMDouble> *amount;
@property (nonatomic, copy) NSString *amountString;
@property (nonatomic, copy) NSString *txHash;
@property (nonatomic) NSNumber<RLMDouble> *dateNumber;
@property (nonatomic, copy) NSString *shortDateString;
@property (nonatomic, copy) NSString *fullDateString;
@property (nonatomic) BOOL send;
@property (assign, nonatomic) BOOL confirmed;
@property (assign, nonatomic) BOOL isSmartContractCreater;
@property (strong, nonatomic) RLMArray<HistoryElementValueRealm*><HistoryElementValueRealm> *fromAddreses;
@property (strong, nonatomic) RLMArray<HistoryElementValueRealm*><HistoryElementValueRealm> *toAddresses;
@end
