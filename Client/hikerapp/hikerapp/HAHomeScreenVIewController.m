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
#import "HABuddyTableViewCell.h"

@interface HAHomeScreenVIewController () <BeaconstacDelegate>

@property (nonatomic, strong) Beaconstac *beaconstacInstance;

@property (weak, nonatomic) IBOutlet UITableView *tablevIew;
@end

@implementation HAHomeScreenVIewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //BLE beacon setup
    [[MSLogger sharedInstance]setLoglevel:MSLogLevelNone];
    self.beaconstacInstance = [Beaconstac sharedInstanceWithOrganizationId:80 developerToken:@"353e54f0a36e3d64a69d4e9bc292487628dcbf07"];
    self.beaconstacInstance.delegate = self;
    self.beaconstacInstance.beaconaffinity = MSBeaconAffinityLow;

    [self.beaconstacInstance startRangingBeaconsWithUUIDString:BEACON_UDID beaconIdentifier:@"com.hike.hikerapp" filterOptions:nil];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapMenuButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self.tablevIew registerNib:[UINib nibWithNibName:@"HABuddyTableViewCell" bundle:nil] forCellReuseIdentifier:@"buddyCell"];
    
    self.tablevIew.separatorInset = UIEdgeInsetsMake(0, 75, 0, 0);
    self.tablevIew.tableFooterView = [[UIView alloc] init];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:51.0f/255.0f green:150.0f/255.0f blue:174.0f/255.0f alpha:0.8f];
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HABuddyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buddyCell"];
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
    }
    else if(indexPath.row == 1) {
        
    }
    else {
        
    }
}




@end
