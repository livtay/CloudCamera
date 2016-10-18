//
//  TabBarController.m
//  CloudCamera
//
//  Created by Olivia Taylor on 10/17/16.
//  Copyright © 2016 Olivia Taylor. All rights reserved.
//

#import "TabBarController.h"
#import "ImageCollectionViewController.h"
#import "NewImageViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //Tab bar
    UIViewController *imagesViewController = [[ImageCollectionViewController alloc] initWithNibName:@"ImageCollectionViewController" bundle:nil];
    imagesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"images-tab.png"] tag:0];
    
    UIViewController *newImageViewController = [[NewImageViewController alloc] initWithNibName:@"NewImageViewController" bundle:nil];
    newImageViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"take-tab.png"] tag:0];
    
    //Navigation controllers
    UINavigationController *nav1 = [[UINavigationController alloc] init];
    [nav1 setViewControllers:@[imagesViewController]];
    UINavigationController *nav2 = [[UINavigationController alloc] init];
    [nav2 setViewControllers:@[newImageViewController]];
    
    self.viewControllers = @[nav1, nav2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
