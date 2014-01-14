//
//  AbstractCollectionViewCell.h
//  stackoverflow
//
//  Created by Joseph Chen on 1/14/14.
//  Copyright (c) 2014 Joseph Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellDataItem;
@interface CollectionViewCell : UICollectionViewCell

+ (CGFloat)margin;
+ (CGSize)sizeWithDataItem:(CellDataItem *)dataItem;

@property (strong, nonatomic) CellDataItem *dataItem;

- (void)toggleExpansion;

@end

@interface ChildView : UIView

- (UILabel *)labelAtIndex:(NSInteger)index;
- (void)clearLabels;

@end