//
//  HAHomeScreenVIewController.m
//  hikerapp
//
//  Created by Ravindra Shetty on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HAHomeScreenVIewController.h"
#import "RESideMenu.h"
#import <Beaconstac/Beaconstac.h>

@interface HAHomeScreenVIewController () <BeaconstacDelegate>

@property (nonatomic, strong) Beaconstac *beaconstacInstance;

@end

@implementation HAHomeScreenVIewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.beaconstacInstance = [Beaconstac sharedInstanceWithOrganizationId:80 developerToken:@"353e54f0a36e3d64a69d4e9bc292487628dcbf07"];
    self.beaconstacInstance.delegate = self;
    self.beaconstacInstance.beaconaffinity = MSBeaconAffinityLow;

    [self.beaconstacInstance startRangingBeaconsWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" beaconIdentifier:@"com.hike.hikerapp" filterOptions:nil];
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
}


@end
