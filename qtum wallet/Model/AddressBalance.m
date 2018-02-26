//
//  AddressBalance.m
//  qtum wallet
//
//  Created by Vu Do on 1/31/18.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "AddressBalance.h"

@interface AddressBalance ()
@property (nonatomic, copy) NSNumber *unconfirmedBalance;
@property (nonatomic, copy) NSNumber *balance;
@property (nonatomic, copy) NSNumber *immature;
@end

@implementation AddressBalance
-(void)setupWithObject:(id)object {
    self.unconfirmedBalance = object[@"unconfirmedBalance"];
    self.balance = object[@"balance"];
    self.immature = object[@"immature"];
}

-(NSNumber* )getBalance {
    double value = [self.balance doubleValue]/100000000;
    if (value == 0) {
        // Try to load from database
        
    }
    return [[NSNumber alloc] initWithDouble:value];
}

-(NSNumber *)getUnconfirmedBalance {
    double value = [self.unconfirmedBalance doubleValue]/100000000;
    return [[NSNumber alloc] initWithDouble:value];
}

-(NSNumber *)getImmature {
    double value = [self.immature doubleValue]/100000000;
    return [[NSNumber alloc] initWithDouble:value];
}
@end
