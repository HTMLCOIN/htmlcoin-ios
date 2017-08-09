//
//  QStoreCategory.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreShortContractElement;

@interface QStoreCategory : NSObject

@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *urlPath;
@property (nonatomic, readonly) NSArray<QStoreShortContractElement *> *elements;

- (instancetype)initWithIdentifier:(NSInteger)identifier
                             title:(NSString *)title
                           urlPath:(NSString *)urlPath;

- (void)parseElementsFromJSONArray:(NSArray *)array;

@end
