//
//  CollectionViewController.m
//  stackoverflow
//
//  Created by Joseph Chen on 1/14/14.
//  Copyright (c) 2014 Joseph Chen. All rights reserved.
//

#import "CollectionViewController.h"

#import "CellDataItem.h"
#import "CollectionViewCell.h"

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *cellData;

@end

NSString *const kCollectionViewCellIdentifier = @"Cell";

@implementation CollectionViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)cellData
{
    if (!_cellData) {
        NSInteger countValues = 20;
        _cellData = [[NSMutableArray alloc] initWithCapacity:countValues];
        for (NSInteger i = 0; i < countValues; i++) {
            CellDataItem *item = [[CellDataItem alloc] init];
            item.number = @(arc4random() % 100);
            [_cellData addObject:item];
        }
    }
    return _cellData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [CollectionViewCell sizeWithDataItem:nil];
    layout.minimumInteritemSpacing = [CollectionViewCell margin];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor darkGrayColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    self.collectionView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, layout.itemSize.height);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier
                                                         forIndexPath:indexPath];
    cell.dataItem = [self.cellData objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [CollectionViewCell sizeWithDataItem:[self.cellData objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell toggleExpansion];
    [collectionView reloadData];
}

@end
