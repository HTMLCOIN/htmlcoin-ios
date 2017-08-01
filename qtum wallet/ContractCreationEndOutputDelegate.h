//
//  ContractCreationEndOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContractCreationEndOutputDelegate <NSObject>

- (void)didPressedQuit;
- (void)finishStepFinishDidPressed;
- (void)finishStepBackDidPressed;

@end
