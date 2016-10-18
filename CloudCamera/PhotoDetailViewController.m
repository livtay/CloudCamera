//
//  PhotoDetailViewController.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/18/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Detail";
    self.commentTable.delegate = self;
    self.commentTable.dataSource = self;
    self.likeLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.imageView.image = self.image.image;
    self.likeLabel.text = [NSString stringWithFormat:@"%d likes", self.image.likes];
    
    if (self.image.likes == 0) {
        self.likeLabel.hidden = YES;
        [self.likeButton setImage:[UIImage imageNamed:@"icn_like"] forState:UIControlStateNormal];
    } else {
        self.likeLabel.hidden = NO;
        [self.likeButton setImage:[UIImage imageNamed:@"icn_active"] forState:UIControlStateNormal];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

- (IBAction)likePressed:(id)sender {
    
    [self.likeButton setImage:[UIImage imageNamed:@"icn_active"] forState:UIControlStateNormal];
    self.image.likes++;
    self.likeLabel.hidden = NO;
    self.likeLabel.text = [NSString stringWithFormat:@"%d likes", self.image.likes];
    
    [[DAO sharedInstance] updatePhotoDetailsInFirebase:self.image];
}

- (IBAction)morePressed:(id)sender {
    
    UIAlertController *moreOptions = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Photo"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [self deletePhoto];
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [moreOptions dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [moreOptions addAction:delete];
    [moreOptions addAction:cancel];
    [self presentViewController:moreOptions animated:YES completion:nil];
    
}

- (void)deletePhoto {
    
    [[DAO sharedInstance] deletePhotoDetailsFromDatabase:self.image];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)commentPressed:(id)sender {
    
}


@end


































