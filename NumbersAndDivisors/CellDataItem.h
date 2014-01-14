//
//  CellDataItem.h
//  stackoverflow
//
//  Created by Joseph Chen on 1/14/14.
//  Copyright (c) 2014 Joseph Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellDataItem : NSObject

@property (strong, nonatomic) NSNumber *number;
@property (nonatomic, readonly) NSArray *divisors;
@property (nonatomic, getter = isExpanded) BOOL expanded;

@end
