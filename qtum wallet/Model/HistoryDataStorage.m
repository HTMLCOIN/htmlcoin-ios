//
//  HistoryDataStorage.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryDataStorage.h"
#import "DatabaseManager.h"

NSString *const HistoryUpdateEvent = @"HistoryUpdateEvent";

@interface HistoryDataStorage ()

@property (strong, nonatomic) NSMutableArray<HistoryElement*>* historyPrivate;

@end

@implementation HistoryDataStorage


#pragma mark - Private Methods

-(void)notificateChangeHistory{
    [self.spendableOwner historyDidChange];
}

#pragma mark Public Methods

- (void)setHistory:(NSArray<HistoryElement*>*) history{
    self.historyPrivate = [[history reverseObjectEnumerator] allObjects].mutableCopy;
    [[DatabaseManager sharedInstance] storeTransactionHistory:history];
    [self notificateChangeHistory];
}

- (NSArray<HistoryElement*>*)getHistory {
    if(_historyPrivate.count == 0)
        _historyPrivate = [[DatabaseManager sharedInstance] loadHistory];
    
    return _historyPrivate;
}

- (NSArray<HistoryElement*>*)history{
    return [_historyPrivate copy];
}

- (void)setHistoryItem:(HistoryElement*) item{
    NSUInteger  index = [self.historyPrivate indexOfObjectPassingTest:^BOOL(HistoryElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualElementWithoutConfimation:item]) {
            return YES;
        }
        return NO;
    }];

    if (index < self.historyPrivate.count) {
        self.historyPrivate[index] = item;
    } else {
        [self.historyPrivate insertObject:item atIndex:0];
    }
    
    [[DatabaseManager sharedInstance] storeTransactionHistory:[NSArray arrayWithObject:item]];
    [self notificateChangeHistory];
}

- (void)deleteHistoryItem:(HistoryElement*) item{
    [self.historyPrivate removeObject:item];
    
    [[DatabaseManager sharedInstance] deleteTransactionHistory:[NSArray arrayWithObject:item]];
    [self notificateChangeHistory];
}

- (HistoryElement*)updateHistoryItem:(HistoryElement*) item{
    //TODO
    if ([self.historyPrivate containsObject:item]) {
        
    }
    
    [[DatabaseManager sharedInstance] storeTransactionHistory:[NSArray arrayWithObject:item]];
    [self notificateChangeHistory];
    return nil;
}

- (void)addHistoryElements:(NSArray<HistoryElement*>*) elements{
    
    [self.historyPrivate addObjectsFromArray:[[elements reverseObjectEnumerator] allObjects]];
    
    [[DatabaseManager sharedInstance] storeTransactionHistory:elements];
    [self notificateChangeHistory];
}


@end
