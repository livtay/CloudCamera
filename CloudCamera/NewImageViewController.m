//
//  NewImageViewController.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/17/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "NewImageViewController.h"
#import "Image.h"

@interface NewImageViewController ()

@property (weak, nonatomic) UIImage *selectedImage;

@end

@implementation NewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.44 green:0.45 blue:0.57 alpha:1.0];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self uploadPhoto];
    }
    
    [self.takePhotoButton addTarget:self
                             action:@selector(takePhoto)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.uploadPhotoButton addTarget:self
                               action:@selector(uploadPhoto)
                     forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.title = @"Photo Library";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
   
}

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self uploadPhoto];
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)uploadPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.selectedImage = info[UIImagePickerControllerEditedImage];
    
    Image *newImage = [[Image alloc] initWithImage:self.selectedImage andDate:[NSDate date]];
    newImage.imageName = [NSString stringWithFormat:@"%d", newImage.imageId];
    newImage.imageName = [newImage.imageName stringByAppendingString:@".jpg"];
    NSLog(@"You added a new image! The image name is: %@", newImage.imageName);
    
    [[DAO sharedInstance] addPhotoDetailsToFirebaseDatabase:newImage];
    
    [self.tabBarController setSelectedIndex:0];
}


@end



































