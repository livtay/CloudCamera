//
//  PhotoDetailViewController.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/18/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Comment.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Detail";
    self.commentTable.delegate = self;
    self.commentTable.dataSource = self;
    self.addCommentField.delegate = self;
    self.likeLabel.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageView.image = self.image.image;
    self.likeLabel.text = [NSString stringWithFormat:@"%d likes", self.image.likes];
    
    if (self.image.likes == 0) {
        self.likeLabel.hidden = YES;
        [self.likeButton setImage:[UIImage imageNamed:@"icn_like"] forState:UIControlStateNormal];
    } else {
        self.likeLabel.hidden = NO;
        [self.likeButton setImage:[UIImage imageNamed:@"icn_active"] forState:UIControlStateNormal];
    }
    
    self.addCommentField.hidden = YES;
    [self.commentTable reloadData];
//    [DAO sharedInstance]
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.image.comments.count;
}

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
    
    self.addCommentField.text = @"";
    
    if (self.addCommentField.hidden == YES) {
        self.addCommentField.hidden = NO;
    } else {
        self.addCommentField.hidden = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        cell.textLabel.numberOfLines = 0;
    }
    
    Comment *newComment = self.image.comments[indexPath.row];
    NSString *commentString = [NSString stringWithFormat:@"%@: %@", newComment.username, newComment.comment];
    cell.textLabel.text = commentString;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addComment];
    return YES;
}

- (void)addComment {
    
    self.addCommentField.hidden = YES;
    
    Comment *newComment = [[Comment alloc] init];
    newComment.username = @"livtay";
    newComment.comment = self.addCommentField.text;
    [self.image.comments addObject:newComment];
    
    [[DAO sharedInstance] updatePhotoDetailsInFirebase:self.image];
    [self.commentTable reloadData];
    [self.view endEditing:YES];
}


@end


































