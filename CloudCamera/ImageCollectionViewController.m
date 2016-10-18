//
//  ImageCollectionViewController.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/17/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "DAO.h"
#import "CollectionViewCell.h"
#import "Image.h"
#import "PhotoDetailViewController.h"

@interface ImageCollectionViewController ()

@property (retain, nonatomic) DAO *dao;
@property (nonatomic, retain) PhotoDetailViewController *pdvc;

@end

@implementation ImageCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Moments";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.44 green:0.45 blue:0.57 alpha:1.0];
    
    self.dao = [DAO sharedInstance];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotification)
                                                 name:@"Update"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = NO;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dao.images.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize collectionViewSize = collectionView.bounds.size;
    collectionViewSize.width = collectionViewSize.height = collectionViewSize.width/3.0;
    
    return collectionViewSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Image *imageView = [self.dao.images objectAtIndex:indexPath.row];
    cell.imageView.image = imageView.image;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.pdvc = [[PhotoDetailViewController alloc] init];
    self.pdvc.image = [self.dao.images objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.pdvc animated:YES];
}

- (void)updateNotification {
    
    [self.collectionView reloadData];
}


@end
























