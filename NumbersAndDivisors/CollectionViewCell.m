//
//  AbstractCollectionViewCell.m
//  stackoverflow
//
//  Created by Joseph Chen on 1/14/14.
//  Copyright (c) 2014 Joseph Chen. All rights reserved.
//

#import "CollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CellDataItem.h"

@interface CollectionViewCell ()

@property (strong, nonatomic) NSMutableArray *childViews;
@property (strong, nonatomic) UILabel *numberLabel;

@end

NSInteger const kCollectionViewCellSplitCount = 4;
CGFloat const kCollectionViewCellMargin = 20.0f;
CGSize const kCollectionViewCellDefaultSize = {200.0f, 200.0f};

@implementation CollectionViewCell

+ (CGFloat)margin
{
    return kCollectionViewCellMargin;
}

+ (CGSize)sizeWithDataItem:(CellDataItem *)dataItem
{
    if (dataItem && dataItem.isExpanded) {
        CGSize size = kCollectionViewCellDefaultSize;
        NSInteger childViewsRequired = [self childViewsRequiredForDataItem:dataItem];
        size.width += childViewsRequired * ([self margin] + size.width);
        return size;
    } else {
        return kCollectionViewCellDefaultSize;
    }
}

+ (NSInteger)childViewsRequiredForDataItem:(CellDataItem *)dataItem
{
    return (NSInteger)ceilf((float)dataItem.divisors.count / (float)kCollectionViewCellSplitCount);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _numberLabel.layer.borderWidth = 1.0f;
        _numberLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_numberLabel];
    }
    return self;
}

- (void)setDataItem:(CellDataItem *)dataItem
{
    if (_dataItem == dataItem) {
        return;
    }
    
    _dataItem = dataItem;
    self.numberLabel.text = [NSString stringWithFormat:@"%i", dataItem.number.integerValue];
    
    if (!dataItem.expanded) {
        [self collapse];
    } else if (dataItem.expanded) {
        [self expand];
    }
}

- (void)collapse
{
    for (ChildView *view in self.childViews) {
        view.hidden = YES;
    }
}

- (void)expand
{
    NSInteger childViewsRequired = [self.class childViewsRequiredForDataItem:self.dataItem];
    while (self.childViews.count < childViewsRequired) {
        ChildView *childView = [[ChildView alloc] init];
        [self.childViews addObject:childView];
        [self.contentView addSubview:childView];
    }
    
    NSInteger index = 0;
    for (ChildView *view in self.childViews) {
        view.hidden = !(index < childViewsRequired);
        if (!view.hidden) {
            [view clearLabels];
        }
        index++;
    }
    
    for (NSInteger i = 0; i < self.dataItem.divisors.count; i++) {
        NSInteger labelsPerChild = 4;
        NSInteger childIndex = i / labelsPerChild;
        NSInteger labelIndex = i % labelsPerChild;
        [[[self.childViews objectAtIndex:childIndex] labelAtIndex:labelIndex] setText:[NSString stringWithFormat:@"%i", [[self.dataItem.divisors objectAtIndex:i] integerValue]]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat const unitWidth = kCollectionViewCellDefaultSize.width;
    CGFloat const unitHeight = kCollectionViewCellDefaultSize.height;
    CGFloat const margin = [self.class margin];
    self.numberLabel.frame = CGRectMake(0.0f, 0.0f, unitWidth, unitHeight);
    
    for (NSInteger i = 0; i < self.childViews.count; i++) {
        ChildView *view = [self.childViews objectAtIndex:i];
        view.frame = CGRectMake((i + 1) * (margin + unitWidth), 0.0f, unitWidth, unitHeight);
    }
}

- (NSMutableArray *)childViews
{
    if (!_childViews) {
        _childViews = [[NSMutableArray alloc] init];
    }
    return _childViews;
}

- (void)toggleExpansion
{
    self.dataItem.expanded = !self.dataItem.isExpanded;
    if (self.dataItem.isExpanded) {
        [self expand];
    } else {
        [self collapse];
    }
}

@end

@interface ChildView ()

@property (strong, nonatomic) NSMutableArray *labels;

@end

@implementation ChildView

- (id)init
{
    if ((self = [super init])) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (UILabel *)labelAtIndex:(NSInteger)index
{
    if (!self.labels) {
        self.labels = [NSMutableArray array];
    }
    
    while (self.labels.count <= index) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1.0f;
        [self.labels addObject:label];
        [self addSubview:label];
    }
    
    return [self.labels objectAtIndex:index];
}

- (void)clearLabels
{
    for (UILabel *label in self.labels) {
        label.text = nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelWidth = self.bounds.size.width * 0.5f;
    CGFloat labelHeight = self.bounds.size.height * 0.5f;
    for (NSInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        NSInteger x = i % 2;
        NSInteger y = i / 2;
        label.frame = CGRectMake(x * labelWidth, y * labelHeight, labelWidth, labelHeight);
    }
}

@end
