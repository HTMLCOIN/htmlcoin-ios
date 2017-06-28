//
//  QStoreListTableSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QStoreListTableSourceDelegate <NSObject>

- (void)didSelectCell;

@end

@interface QStoreListTableSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<QStoreListTableSourceDelegate> delegate;

@end
