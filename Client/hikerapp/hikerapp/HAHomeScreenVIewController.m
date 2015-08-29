//
//  HAHomeScreenVIewController.m
//  hikerapp
//
//  Created by Ravindra Shetty on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HAHomeScreenVIewController.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import <Beaconstac/Beaconstac.h>
#import "HACommonDefs.h"

@interface HAHomeScreenVIewController () <BeaconstacDelegate>

@property (nonatomic, strong) Beaconstac *beaconstacInstance;

@end

@implementation HAHomeScreenVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beaconstacInstance = [Beaconstac sharedInstanceWithOrganizationId:80 developerToken:@"353e54f0a36e3d64a69d4e9bc292487628dcbf07"];
    self.beaconstacInstance.delegate = self;
    self.beaconstacInstance.beaconaffinity = MSBeaconAffinityLow;

    [self.beaconstacInstance startRangingBeaconsWithUUIDString:BEACON_UDID beaconIdentifier:@"com.hike.hikerapp" filterOptions:nil];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapMenuButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)didTapMenuButton:(id)sender {
    [self presentLeftMenuViewController:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Beacons
- (void)beaconstac:(Beaconstac *)beaconstac rangedBeacons:(NSDictionary *)beaconsDictionary
{
    NSLog(@"Beacons around %@",beaconsDictionary);
}


- (void)beaconstac:(Beaconstac *)beaconstac campedOnBeacon:(MSBeacon *)beacon amongstAvailableBeacons:(NSDictionary *)beaconsDictionary
{
    NSLog(@"Camped on beacon %@",beacon);

    MSBeacon *campedBeacon = (MSBeacon*)beacon;
    NSString *location = [[campedBeacon.beaconKey uppercaseString] stringByReplacingOccurrencesOfString:BEACON_UDID withString:@""];
    NSString *exactLocation = UNKNOWN_LOCATION;
    if([location isEqualToString:@"6616:56252"]) {
        exactLocation = @"Cafeteria";
        NSLog(@"Camped on CAFE");
    }
    else if([location isEqualToString:@"49201:35267"]){
        exactLocation = @"Desk";
        NSLog(@"Camped on DESK");
    }

    //Send location to server if it has changed
}


@end
