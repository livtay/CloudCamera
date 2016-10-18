//
//  Image.h
//  CloudCamera
//
//  Created by Olivia Taylor on 10/14/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Image : NSObject

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *imageName;
@property (retain, nonatomic) NSDate *dateAdded;
@property (retain, nonatomic) NSString *creator;
@property (retain, nonatomic) NSURL *filePath;
@property int imageId;

- (instancetype)initWithImage:(UIImage *)image andDate:(NSDate *)dateAdded;

@end