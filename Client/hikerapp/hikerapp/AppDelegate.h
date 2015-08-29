//
//  AppDelegate.h
//  hikerapp
//
//  Created by Himadri Jyoti on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerForRemoteNotifications;

- (void)showLoader:(BOOL)show;

- (void)handleSignUpComplete;

+ (AppDelegate *)sharedAppDelegate;

- (void)scheduleLocalNNotification;

@end

