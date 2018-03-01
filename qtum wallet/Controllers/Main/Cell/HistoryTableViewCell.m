//
//  HestoryTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@end

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setHistoryElement:(HistoryElement *)historyElement {
    
    _historyElement = historyElement;
    
    self.addressLabel.text = historyElement.address;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 8;
    
    NSString *result = [formatter stringFromNumber:[NSNumber numberWithDouble:[self.historyElement.amount floatValue]]];
    self.amountLabel.text = self.symbolLabel ? result : historyElement.amountString;
    self.dateLabel.text = (historyElement.shortDateString && historyElement.shortDateString.length > 0) ? historyElement.shortDateString : NSLocalizedString(@"Unconfirmed", nil);
    
//    if (historyElement.send) {
//        self.typeLabel.text = NSLocalizedString(@"Sent", "");
//        self.addressLabel.text = [historyElement.toAddresses firstObject][@"address"];
//    }else{
//        self.typeLabel.text = NSLocalizedString(@"Received", "");
//        self.addressLabel.text = [historyElement.fromAddreses firstObject][@"address"];
//    }
    self.addressLabel.text = historyElement.txHash;
}

- (void)changeHighlight:(BOOL)value { }

@end
