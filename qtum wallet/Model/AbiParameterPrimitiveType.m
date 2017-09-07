//
//  AbiParameterPrimitiveType.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiParameterPrimitiveType.h"

@implementation AbiParameterPrimitiveType

- (instancetype)initWithSize:(NSUInteger) size {
    
    self = [super init];
    if (self) {
        _size = size;
    }
    return self;
}

-(NSInteger)maxValue {
    
    return pow(2, self.size);
}

@end
