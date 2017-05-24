//
//  TokenDetailsTableSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@protocol TokenDetailsTableSourceDelegate <NSObject>

- (void)scrollViewDidScrollWithSecondSectionHeaderY:(CGFloat)headerY;
- (void)didPressedInfoActionWithToken:(Token*) token;

@end

@interface TokenDetailsTableSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TokenDetailsTableSourceDelegate> delegate;
@property (nonatomic, strong) Token* token;

@end
