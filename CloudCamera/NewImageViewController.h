//
//  NewImageViewController.h
//  CloudCamera
//
//  Created by Olivia Taylor on 10/17/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface NewImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;

@end
