//
//  BalanceRealm.h
//  qtum wallet
//
//  Created by Long Pham on 26/02/2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface AddressBalanceRealm : RLMObject

@property (strong, nonatomic) NSString* balance;
@property (strong, nonatomic) NSString* unconfirmedBalance;
@end
