//
//  JCAnimatedCollectionViewDemoViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 10/02/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCAnimatedCollectionViewDemoViewController.h"
#import "JCAnimatedCollectionViewCell.h"

#import "JCUtils.h"
#import "UIView+JCUtils.h"
#import "UIColor+JCUtils.h"

NSString *const JC_ANIMATED_COLLECTION_VIEW_CELL_IDENTIFIER = @"jcAnimatedCollectionViewCellIdentifier";

typedef NS_ENUM(NSInteger, JCAnimatedCollectionViewOperation){
    JCAnimatedCollectionViewOperationAdd,
    JCAnimatedCollectionViewOperationDelete,
    JCAnimatedCollectionViewOperationUpdate
};

@interface JCAnimatedCollectionViewDemoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

@property (assign, nonatomic) JCAnimatedCollectionViewOperation operation;
@property (strong, nonatomic) NSArray<NSNumber *> *itemCounts;

@end





@implementation JCAnimatedCollectionViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    [self setupNavigationBar];
    [self setupCollectionView];
    [self onAddClicked:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [_collectionView reloadData];
    }];
}

- (void)setupNavigationBar{
    self.title = @"Animated CollectionView Demo";
    [self setLeftBarButtonType:LeftBarButtonTypeBack];
}

- (void)setupCollectionView{
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    NSBundle *bundle = [NSBundle bundleForClass:[JCAnimatedCollectionViewCell class]];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JCAnimatedCollectionViewCell class]) bundle:bundle] forCellWithReuseIdentifier:JC_ANIMATED_COLLECTION_VIEW_CELL_IDENTIFIER];
    _collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger sectionNumber = 3;
    
    if(!_itemCounts){
        NSMutableArray *mutableItemCount = [NSMutableArray array];
        for(NSInteger i = 0; i < sectionNumber; i++){
            [mutableItemCount addObject:@(1)];
        }
        _itemCounts = [NSArray arrayWithArray:mutableItemCount];
    }
    
    return sectionNumber;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (_itemCounts[section]).integerValue;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat maxSize = 115;
    CGFloat size = MIN(([JCUtils screenWidth] - 20) / 3, maxSize);
    
    return CGSizeMake(size, size);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 5, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JCAnimatedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JC_ANIMATED_COLLECTION_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.lbTitle.text = [NSString stringWithFormat:@"I am cell %ld", (long)indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    switch (_operation) {
        case JCAnimatedCollectionViewOperationAdd:
            [self addCellToCollectionView:collectionView atIndexPath:indexPath];
            break;
            
        case JCAnimatedCollectionViewOperationDelete:
            [self deleteCellFromCollectionView:collectionView atIndexPath:indexPath];
            break;
            
        case JCAnimatedCollectionViewOperationUpdate:
            [self updateCellInCollectionView:collectionView atIndexPath:indexPath];
            break;
    }
}

#pragma mark - actions
- (IBAction)onAddClicked:(id)sender {
    _operation = JCAnimatedCollectionViewOperationAdd;
    _btnAdd.backgroundColor = [UIColor appMainColor];
    _btnDelete.backgroundColor = [UIColor whiteColor];
    _btnUpdate.backgroundColor = [UIColor whiteColor];
    
    [_btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnDelete setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnUpdate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (IBAction)onDeleteClicked:(id)sender {
    _operation = JCAnimatedCollectionViewOperationDelete;
    _btnAdd.backgroundColor = [UIColor whiteColor];
    _btnDelete.backgroundColor = [UIColor appMainColor];
    _btnUpdate.backgroundColor = [UIColor whiteColor];
    
    [_btnAdd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnUpdate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (IBAction)onUpdateClicked:(id)sender {
    _operation = JCAnimatedCollectionViewOperationUpdate;
    _btnAdd.backgroundColor = [UIColor whiteColor];
    _btnDelete.backgroundColor = [UIColor whiteColor];
    _btnUpdate.backgroundColor = [UIColor appMainColor];
    
    [_btnAdd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnDelete setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)addCellToCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray<NSNumber *> *mutableItemCount = [_itemCounts mutableCopy];
    NSInteger itemCount = (mutableItemCount[indexPath.section]).integerValue;
    mutableItemCount[indexPath.section] = @(itemCount + 1);
    _itemCounts = [NSArray arrayWithArray:mutableItemCount];
    
    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]]];
}

- (void)deleteCellFromCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray<NSNumber *> *mutableItemCount = [_itemCounts mutableCopy];
    NSInteger itemCount = (mutableItemCount[indexPath.section]).integerValue;
    mutableItemCount[indexPath.section] = @(itemCount - 1);
    _itemCounts = [NSArray arrayWithArray:mutableItemCount];
    
    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)updateCellInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

@end
