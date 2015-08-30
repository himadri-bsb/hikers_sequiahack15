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
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import "HASettingsViewController.h"
#import <Parse/Parse.h>
#import "HACommonDefs.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()
@property (strong, nonatomic) UILocalNotification *takeWalkNotif;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Digits class]]];

    // Initialize Parse.
    [Parse setApplicationId:@"qLlhWwYL79kT5t5ZnRh7no5Ty8OaNwbVdIo3Nfpf"
                  clientKey:@"DdpySFGhZUZ24wp9aS1pb83HcZAy6vVlqlVYSocW"];

    [self setUpRootVC];
    return YES;
}


- (void)setUpRootVC {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([self signedIn]) {
        [self showHomeScreen];
    } else {
        HASignupInfoViewController *signUpViewController = [[HASignupInfoViewController alloc] init];
        signUpViewController.isSignUpMode = YES;
        UINavigationController *navigationVC = [[UINavigationController alloc] init];
        [navigationVC.navigationBar setBarTintColor:[UIColor colorWithRed:51.0f/255.0f green:150.0f/255.0f blue:174.0f/255.0f alpha:0.8f]];
        [navigationVC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [navigationVC.navigationBar setTintColor:[UIColor whiteColor]];
        Digits *digits = [Digits sharedInstance];
        DGTAppearance *appearance = [[DGTAppearance alloc] init];
        appearance.accentColor = [UIColor colorWithRed:51.0f/255.0f green:150.0f/255.0f blue:174.0f/255.0f alpha:0.8f];
        [digits authenticateWithNavigationViewController:navigationVC phoneNumber:@"+91" digitsAppearance:appearance title:nil completionViewController:signUpViewController];
        self.window.rootViewController = navigationVC;
    }
    [self.window makeKeyAndVisible];

    if([self signedIn]) {
        //Register for remote notification, this method needs to be called after signup as well
        [self registerForRemoteNotifications];
    }
}

- (void)registerForRemoteNotifications {
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (BOOL)signedIn {
    return ([PFUser currentUser] != nil);
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
    if ([PFUser currentUser]) {
        //save the installation
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[INSTALLATION_USER_ID] = [[PFUser currentUser] objectId];
        // here we add a column to the installation table and store the current user’s ID
        // this way we can target specific users later

        // while we’re at it, this is a good place to reset our app’s badge count
        // you have to do this locally as well as on the parse server by updating
        // the PFInstallation object
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error is saving installation");
            }
            else {
                // only update locally if the remote update succeeded so they always match
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                NSLog(@"updated badge");
            }
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//Push notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);

    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // Play a sound and show an alert only if the application is active, to avoid doubly notifiying the user.
    if([notification.alertBody isEqualToString:self.takeWalkNotif.alertBody]) {
        if ([application applicationState] == UIApplicationStateActive) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take a Walk!!"
                                                            message:[notification alertBody]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okey"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [self cancelNotificationNotification];
    }
}


- (void)showLoader:(BOOL)show {
    if (show) {
        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD show];
    }
    else {
        [SVProgressHUD dismiss];
    }
}

+ (AppDelegate *)sharedAppDelegate {
    return  (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)handleSignUpComplete {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLocationPrivacyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self registerForRemoteNotifications];
    [self showHomeScreen];
}

- (void)showHomeScreen {
    HAHomeScreenVIewController *homeScreen = [[HAHomeScreenVIewController alloc] initWithNibName:@"HAHomeScreenVIewController" bundle:nil];
    UINavigationController *navigatioNVC = [[UINavigationController alloc] initWithRootViewController:homeScreen];
    
    
    HALeftMenuViewController *leftMenu = [[HALeftMenuViewController alloc] initWithNibName:@"HALeftMenuViewController" bundle:nil];
    
    RESideMenu *slideMenu = [[RESideMenu alloc] initWithContentViewController:navigatioNVC leftMenuViewController:leftMenu rightMenuViewController:nil];
    slideMenu.backgroundImage = [UIImage imageNamed:@"signup_bg"];
    slideMenu.contentViewInPortraitOffsetCenterX = -50;
    self.window.rootViewController = slideMenu;
}


- (void)scheduleLocalNNotification {
    if (self.takeWalkNotif) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.takeWalkNotif];
    }
    
    self.takeWalkNotif = [[UILocalNotification alloc] init];
    
    NSDictionary *alertValue = [[NSUserDefaults standardUserDefaults] valueForKey:kWalkAlertKey];
    NSTimeInterval interval = [[[alertValue allValues] firstObject] floatValue]*60.0f;
    if (interval >= 10) {
        NSDate *now = [NSDate date];
        NSDate *dateToFire = [now dateByAddingTimeInterval:interval];
        self.takeWalkNotif.fireDate = dateToFire;
        if (interval > 60) {
            self.takeWalkNotif.alertBody = [NSString stringWithFormat:@"Hey, You are sitting at your desk from past %@ mins! Get up and take some walk.",[[alertValue allValues] firstObject]];
        }
        else {
            self.takeWalkNotif.alertBody = [NSString stringWithFormat:@"Hey, You are sitting at your desk from past %.0f secs! Get up and take some walk.",interval];
        }
        
        self.takeWalkNotif.soundName = UILocalNotificationDefaultSoundName;
        self.takeWalkNotif.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:self.takeWalkNotif];
    }
}

- (void)cancelNotificationNotification {
    if (self.takeWalkNotif) {
        [[NSUserDefaults standardUserDefaults] setValue:@{@"Off":@"0"} forKey:kWalkAlertKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[UIApplication sharedApplication] cancelLocalNotification:self.takeWalkNotif];
    }
}

-(void)didUpdatedLocation:(NSNotification *)notif {
    [self scheduleLocalNNotification];
}


@end
