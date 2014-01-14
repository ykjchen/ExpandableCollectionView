//
//  CellDataItem.m
//  stackoverflow
//
//  Created by Joseph Chen on 1/14/14.
//  Copyright (c) 2014 Joseph Chen. All rights reserved.
//

#import "CellDataItem.h"

@interface CellDataItem ()

@property (strong, nonatomic) NSArray *divisors;

@end

@implementation CellDataItem

+ (NSArray *)divisorsForNumber:(NSNumber *)number
{
    NSMutableArray *divisors = [NSMutableArray arrayWithObjects:@(1), number, nil];
    float root = pow(number.doubleValue, 0.5);
    if (root == roundf(root)) {
        [divisors addObject:[NSNumber numberWithInteger:(NSInteger)root]];
    }
    
    NSInteger maxDivisor = (NSInteger)root;
    for (NSInteger divisor = 2; divisor < maxDivisor; divisor++) {
        float quotient = number.floatValue / (float)divisor;
        if (quotient == roundf(quotient)) {
            [divisors addObject:[NSNumber numberWithInteger:divisor]];
            [divisors addObject:[NSNumber numberWithInteger:(NSInteger)quotient]];
        }
    }
    return [divisors sortedArrayUsingSelector:@selector(compare:)];
}

- (void)setNumber:(NSNumber *)number
{
    if (_number == number) {
        return;
    }
    _number = number;
    self.divisors = [self.class divisorsForNumber:_number];
}

@end
