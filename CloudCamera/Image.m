//
//  Image.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/14/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "Image.h"

@implementation Image

- (instancetype)initWithImage:(UIImage *)image andDate:(NSDate *)dateAdded {
    self = [super init];
    if (self) {
        _image = image;
        _dateAdded = dateAdded;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults integerForKey:@"imageIdCounter"]) {
            [defaults setInteger:1 forKey:@"imageIdCounter"];
            self.imageId = 1;
        } else {
            self.imageId = (int)[defaults integerForKey:@"imageIdCounter"] + 1;
            [defaults setInteger:self.imageId forKey:@"imageIdCounter"];
        }
        
        _likes = 0;
        
        return self;
    }
    return nil;
}

@end
