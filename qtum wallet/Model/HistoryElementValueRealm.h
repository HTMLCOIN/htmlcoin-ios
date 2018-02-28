//
//  HistoryElementValueRealm.h
//  qtum wallet
//
//  Created by Vu Do on 2/26/18.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Realm/Realm.h>

@interface HistoryElementValueRealm : RLMObject
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* value;
@property (strong, nonatomic) NSString* spentTxId;
@end

RLM_ARRAY_TYPE(HistoryElementValueRealm)
