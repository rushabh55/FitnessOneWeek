//
//  ViewController.m
//  FitnessProjectOneWeek
//
//  Created by redmond\rugos on 7/19/17.
//  Copyright © 2017 Rushabh Gosar. All rights reserved.
//
@import Foundation;
#import "StartExperience.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginButton.h>
#import "ThreadingUtils.h"
@interface StartExperience ()

@end

@implementation StartExperience

- (void)viewDidLoad
{
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error)
     {
         NSDictionary *dictionary = (NSDictionary *)result;
         NSString *email = [dictionary objectForKey:@"email"];
         if (email.length)
         {
             [ThreadingUtils onMainThreadSyncSafe:^{
                 [self performSegueWithIdentifier:@"pushMain" sender:self];
             }];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
