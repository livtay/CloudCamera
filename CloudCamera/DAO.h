//
//  DAO.h
//  CloudCamera
//
//  Created by Olivia Taylor on 10/14/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "NewImageViewController.h"
@import Firebase;
@import FirebaseStorage;

@interface DAO : NSObject

@property (retain, nonatomic) NSMutableArray<Image*> *images;

+ (DAO *)sharedInstance;
- (void)addPhotoDetailsToFirebaseDatabase:(Image *)newImage;

@end
