//
//  ContractFileManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateModel.h"

@interface ContractFileManager : NSObject

- (NSArray*)abiWithTemplate:(NSString*) templatePath;

- (NSString*)escapeAbiWithTemplate:(NSString*) templatePath;

- (NSString*)contractWithTemplate:(NSString*) templatePath;

- (NSData*)bitcodeWithTemplate:(NSString*) templatePath;

- (NSArray*)standartAbi;

- (NSDate*)dateOfCreationTemplate:(NSString*) templatePath;

- (BOOL)writeNewAbi:(NSArray*) abi withPathName:(NSString*) templatePath;
- (BOOL)writeNewBitecode:(NSString*) bitecode withPathName:(NSString*) templatePath;
- (BOOL)writeNewSource:(NSString*) source withPathName:(NSString*) templatePath;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));


@end
