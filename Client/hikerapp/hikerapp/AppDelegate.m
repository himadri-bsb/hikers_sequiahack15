//
//  AppDelegate.m
//  hikerapp
//
//  Created by Himadri Jyoti on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "AppDelegate.h"
#import "RESideMenu.h"
#import "HAHomeScreenVIewController.h"
#import "HASignupInfoViewController.h"
#import "HALeftMenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpRootVC];
    return YES;
}


- (void)setUpRootVC {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([self signedIn]) {
        HAHomeScreenVIewController *homeScreen = [[HAHomeScreenVIewController alloc] initWithNibName:@"HAHomeScreenVIewController" bundle:nil];
        UINavigationController *navigatioNVC = [[UINavigationController alloc] initWithRootViewController:homeScreen];
        
        
        HALeftMenuViewController *leftMenu = [[HALeftMenuViewController alloc] initWithNibName:@"HALeftMenuViewController" bundle:nil];
        
        RESideMenu *slideMenu = [[RESideMenu alloc] initWithContentViewController:navigatioNVC leftMenuViewController:leftMenu rightMenuViewController:nil];
        slideMenu.backgroundImage = [UIImage imageNamed:@"signup_bg"];
        slideMenu.contentViewInPortraitOffsetCenterX = -50;
        self.window.rootViewController = slideMenu;
    } else {
        HASignupInfoViewController *signUpViewController = [[HASignupInfoViewController alloc] init];
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:signUpViewController];
        self.window.rootViewController = navigationVC;
    }
    [self.window makeKeyAndVisible];

    if([self signedIn]) {
        //Register for remote notification, this method needs to be called after signup as well
        [self registerForRemoteNotifications];
    }
}

- (void)registerForRemoteNotifications {
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (BOOL)signedIn {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//Push notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);

}

@end
