//
//  AppDelegate.m
//  LetMeAuth-Integration
//
//  Created by Alexey Aleshkov on 13/12/14.
//  Copyright (c) 2014 Webparadox, LLC. All rights reserved.
//


#import "AppDelegate.h"
#import <LetMeAuth/LetMeAuth.h>
#import <LetMeAuth/LMAStubProvider.h>


@interface AppDelegate ()

@property (strong, nonatomic) id<LMAController> controller;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LMABaseController *controller = [[LMABaseController alloc] init];
    controller.defaultRequestClass = [LMABaseRequest class];

    [controller registerProviderClass:[LMAStubProvider class] forKey:@"test"];

    self.controller = controller;

    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)self = weakSelf;

        [self processStubAuthorization];
    });

    return YES;
}

- (void)processStubAuthorization
{
    // TODO: comment only LMAStubProviderCredentialKey to make error result
    // TODO: comment only LMAStubProviderErrorKey to make credential result
    // TODO: comment both LMAStubProviderCredentialKey and LMAStubProviderErrorKey to make cancel result
    NSDictionary *configuration = @
    {
    LMAStubProviderUrlKey: [NSURL URLWithString:@"testapp112233://url"],
    LMAStubProviderSourceApplicationKey: @"com.test.app",
    LMAStubProviderCredentialKey: @"token",
    //LMAStubProviderErrorKey: [NSError errorWithDomain:@"error.domain.test" code:0 userInfo:nil]
    };

    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"start");
        __strong typeof(weakSelf)self = weakSelf;

        id<LMARequest> request = [self.controller authorizeWithProvider:@"test" configuration:configuration completionHandler:^(NSDictionary *credential, NSError *error) {
            NSLog(@"%@, %@", credential, error);
        }];
        [request start];
    });
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.controller handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.controller handleDidBecomeActive];
}

@end
