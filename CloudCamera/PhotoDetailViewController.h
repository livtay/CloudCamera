//
//  PhotoDetailViewController.h
//  CloudCamera
//
//  Created by Olivia Taylor on 10/18/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "DAO.h"

@interface PhotoDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Image *image;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UITableView *commentTable;

- (IBAction)likePressed:(id)sender;
- (IBAction)morePressed:(id)sender;
- (IBAction)commentPressed:(id)sender;

@end
