//
//  ViewController.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/13/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "ViewController.h"
@import Firebase;
@import FirebaseStorage;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //reference to downloaded image in firebase
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://cloudcamera-497b1.appspot.com>"];
    FIRStorageReference *imagesRef = [storageRef child:@"images"];
    
    NSString *fileName = @"teddy_icon.jpeg";
    FIRStorageReference *teddyRef = [imagesRef child:fileName];
    
    NSString *path = teddyRef.fullPath;
    NSString *name = teddyRef.name;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
