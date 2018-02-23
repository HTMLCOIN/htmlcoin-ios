//
//  HistoryElementRealm.m
//  qtum wallet
//
//  Created by Long Pham on 23/02/2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "HistoryElementRealm.h"

@implementation HistoryElementRealm

+(NSString *)primaryKey {
    return @"txHash";
}
@end
