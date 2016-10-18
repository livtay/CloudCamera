//
//  DAO.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/14/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "DAO.h"

@interface DAO ()

@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSURL *firebaseDatabaseUrl;

@end

@implementation DAO

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithData];
    });
    
    return sharedInstance;
}

- (instancetype)initWithData {
    
    self.images = [[NSMutableArray alloc] init];
    
    FIRStorage *storage = [FIRStorage storage];
    self.storageRef = [storage referenceForURL:@"gs://cloudcamera-497b1.appspot.com"];
    
    self = [super init];
    if (self) {
        self.firebaseDatabaseUrl = [NSURL URLWithString:@"https://cloudcamera-497b1.firebaseio.com/photos2.json"];
        
        [self getDataFromCloud];
    }
    return self;
}

//fetch photos from firebase

- (void)getDataFromCloud {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.firebaseDatabaseUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError *error;
            NSDictionary *fetchedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"%@", error.localizedDescription);
            [self.images removeAllObjects];
            
            NSArray *keys = [fetchedData allKeys];
            for (NSString *key in keys) {
                NSDictionary *dictionary = [fetchedData objectForKey:key];
                
                Image *cloudImage = [[Image alloc] init];
                cloudImage.imageId = [dictionary[@"imageId"] intValue];
                cloudImage.imageName = dictionary[@"name"];
                cloudImage.dateAdded = dictionary[@"date"];
                
                [self getPhotoFromFirebase:cloudImage];
                [self.images addObject:cloudImage];
            }
            
        });
    }];
    [task resume];
}

- (void)getPhotoFromFirebase:(Image *)image {
    
    self.storageRef = [[FIRStorage storage] reference];
    NSString *imageString = [NSString stringWithFormat:@"/images/%@", image.imageName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, image.imageName];
    
    NSString *fileUrl = [NSString stringWithFormat:@"file:%@", filePath];
    [[self.storageRef child:imageString] writeToFile:[NSURL URLWithString:fileUrl] completion:^(NSURL *url, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        image.image = [UIImage imageWithData:data];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Update" object:self userInfo:nil];
    }];
}

//add photo to firebase

- (void)addPhotoDetailsToFirebaseDatabase:(Image *)newImage {
    
    [self.images addObject:newImage];
    
//    self.storageRef = [[FIRStorage storage] reference];
    
    NSString *dateAdded = [NSString stringWithFormat:@"%@", newImage.dateAdded];
    
    NSString *imageId = [NSString stringWithFormat:@"%d", newImage.imageId];
    NSDictionary *imageDictionary = @{@"imageId" : imageId, @"name" : newImage.imageName, @"date" : dateAdded};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imageDictionary options:0 error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.firebaseDatabaseUrl];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"NSURLSession error: %@", error.localizedDescription);
            return;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSError *fileError;
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&fileError];
            if (error) {
                NSLog(@"Error: %@", fileError.localizedDescription);
            }
        }
        
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, newImage.imageName];
        NSData *fileData = UIImageJPEGRepresentation(newImage.image, 1.0);
        [fileData writeToFile:fileName atomically:YES];
        newImage.filePath = [NSURL URLWithString:fileName];
        
        [self addPhotoToFirebaseStorage:newImage];
        
    }];
                                  
    [task resume];
}

- (void)addPhotoToFirebaseStorage:(Image *)image {
    
    NSString *imageString = [NSString stringWithFormat:@"/images/%@", image.imageName];
    FIRStorageReference *imageRef = [self.storageRef child:imageString];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] initWithDictionary:@{@"contentType" : @"image"}];
    
    FIRStorageUploadTask *uploadTask = [imageRef putData:[NSData dataWithContentsOfFile:image.filePath.absoluteString] metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error) {
            NSLog(@"Storage Upload Error: %@", error.localizedDescription);
        }
        #pragma unused (uploadTask)
    }];
    
}

@end














































