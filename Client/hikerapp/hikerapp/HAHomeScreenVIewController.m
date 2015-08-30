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
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "HAModelManager.h"
#import "HAUser.h"

@interface HAHomeScreenVIewController () <UIActionSheetDelegate>

@property (nonatomic, strong) Beaconstac *beaconstacInstance;

@property (weak, nonatomic) IBOutlet UITableView *tablevIew;

@property (nonatomic, strong) HABuddyTableViewCell *tappedCell;

@property (nonatomic, strong) NSMutableArray *usersArray;
@end

@implementation HAHomeScreenVIewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[HAModelManager sharedManager] initializeBeaconStac];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapMenuButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapRefreshButton:)];

    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self.tablevIew registerNib:[UINib nibWithNibName:@"HABuddyTableViewCell" bundle:nil] forCellReuseIdentifier:@"buddyCell"];
    
    self.tablevIew.separatorInset = UIEdgeInsetsMake(0, 75, 0, 0);
    self.tablevIew.tableFooterView = [[UIView alloc] init];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:51.0f/255.0f green:150.0f/255.0f blue:174.0f/255.0f alpha:0.8f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLongPressForCell:) name:kNotification_LongPressTableCell object:nil];
    
    [self refreshData];
}

- (void)handleLongPressForCell:(NSNotification  *)notification {
    self.tappedCell = notification.object;
//    if ([self.tappedCell.locationLabel.text isEqualToString:UNKNOWN_LOCATION]) {
        if (!self.tappedCell.isObserving) {
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Notify?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
            [actionsheet showInView:self.view];
        }
        else {
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Remove Observer?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
            [actionsheet showInView:self.view];
        }
//    }
}

- (void)didTapMenuButton:(id)sender {
    [self presentLeftMenuViewController:nil];
}

- (void)didTapRefreshButton:(id)sender {
    //Refresh code
    [[AppDelegate sharedAppDelegate] showLoader:YES];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HABuddyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buddyCell"];
    HAUser *user = [self.usersArray objectAtIndex:indexPath.row];
    cell.avatarImageView.image = user.image;
    cell.nameLabel.text = user.name;
    cell.locationLabel.text = user.location;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        BOOL shouldSetTrigger = NO;

        HAUser *user = nil;
        if(self.tappedCell) {
            NSIndexPath *indexPath = [self.tablevIew indexPathForCell:self.tappedCell];
            user = [self.usersArray objectAtIndex:indexPath.row];
        }


        if(user) {
            if (self.tappedCell.isObserving) {
                self.tappedCell.isObserving = NO;
                self.tappedCell.notifIndicatorView.hidden = YES;
                shouldSetTrigger = NO;

                [self setLocationTriggerForUserNumber:user.phoneNumber enable:NO];
            }
            else {
                self.tappedCell.isObserving = YES;
                self.tappedCell.notifIndicatorView.hidden = NO;
                shouldSetTrigger = YES;
                
                [self setLocationTriggerForUserNumber:user.phoneNumber enable:YES];
            }
        }

    }
}

- (void)refreshData {
    [[AppDelegate sharedAppDelegate] showLoader:YES];
    HAUser *currentUser = [[HAModelManager sharedManager] currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:currentUser.phoneNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                // The find succeeded. The first 100 objects are available in objects
                //NSLog(@"%@", objects);
                NSMutableArray *usersArray = [[NSMutableArray alloc] initWithCapacity:5];
                for (PFUser *parseUser in objects) {
                    HAUser *user = [[HAUser alloc] initWithPFUser:parseUser];
                    [usersArray addObject:user];
                    
                }
                self.usersArray = usersArray;
                [self.tablevIew reloadData];
            } else {
                // Log details of the failure
                //NSLog(@"Error: %@ %@", error, [error userInfo]);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Refresh Error" message:[NSString stringWithFormat:@"Error = %@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            [[AppDelegate sharedAppDelegate] showLoader:NO];
        });
    }];
}

- (void)setLocationTriggerForUserNumber:(NSString*)msisdn enable:(BOOL)enable {
    NSString *currentUserMsisdn = [[[HAModelManager sharedManager] currentUser] phoneNumber];
    PFQuery *query = [PFQuery queryWithClassName:TRIGGER_CLASS_NAME];
    [query whereKey:TRIGGER_OBSERVER equalTo:currentUserMsisdn];
    [query whereKey:TRIGGER_SENDER equalTo:msisdn];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        if([objects count]) {
            PFObject *existingObj = [objects lastObject];
            existingObj[TRIGGER_OBSERVER] = currentUserMsisdn;
            existingObj[TRIGGER_SENDER] = msisdn;
            existingObj[TRIGGER_ISSET] = enable ? YES_STRING : NO_STRING;
            [existingObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!succeeded) {
                    NSLog(@"Failed to set location trigger existing object, error=%@",error);
                }
            }];
        }
        else {
            //Object doesn't exist
            PFObject *locTrigger = [PFObject objectWithClassName:TRIGGER_CLASS_NAME];
            locTrigger[TRIGGER_OBSERVER] = currentUserMsisdn;
            locTrigger[TRIGGER_SENDER] = msisdn;
            locTrigger[TRIGGER_ISSET] = enable ? YES_STRING : NO_STRING;
            [locTrigger saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!succeeded) {
                    NSLog(@"Failed to set location trigger new object, error=%@",error);
                }
            }];
        }
    }];
}



@end
