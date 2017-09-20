//
//  NewPaymentOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewPaymentOutputDelegate;

@protocol NewPaymentOutput <NSObject>

@property (weak, nonatomic) id <NewPaymentOutputDelegate> delegate;

- (void)setQRCodeItem:(QRCodeItem *)item;
- (void)updateControlsWithTokensExist:(BOOL) isExist
                    choosenTokenExist:(BOOL) choosenExist
                      walletBalance:(NSNumber*) walletBalance
             andUnconfimrmedBalance:(NSNumber*) walletUnconfirmedBalance;
- (void)updateContentWithContract:(Contract*) contract;
- (void)clearFields;
- (void)showErrorPopUp:(NSString *)message;
- (void)showCompletedPopUp;
- (void)showLoaderPopUp;
- (void)hideLoaderPopUp;
- (void)setMinFee:(NSNumber*) minFee andMaxFee:(NSNumber*) maxFee;


@end
