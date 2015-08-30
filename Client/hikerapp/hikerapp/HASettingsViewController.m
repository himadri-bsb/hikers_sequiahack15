//
//  HASettingsViewController.m
//  hikerapp
//
//  Created by Mohan on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HASettingsViewController.h"
#import "HASignupInfoViewController.h"
#import "AppDelegate.h"
#import "HACommonDefs.h"

@interface HASettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIPickerView *durationPickerView;
@property (nonatomic, strong) NSArray *pickerViewDataSource;

@end

@implementation HASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setlayoutConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    NSDictionary *alertValue = [[NSUserDefaults standardUserDefaults] valueForKey:kWalkAlertKey];
    [self resetAlertDurationCellWithValue:alertValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:51.0f/255.0f green:150.0f/255.0f blue:174.0f/255.0f alpha:0.8f]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapMenuButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.title = @"Settings";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

- (void)setlayoutConstraints {
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"view":self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"view":self.tableView}]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.0f;
    } else {
        return 64.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileCell"];
        }
        cell.textLabel.text = @"Profile";
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell1"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsCell1"];
                cell.detailTextLabel.numberOfLines = 0;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Allow to track location";
            cell.detailTextLabel.text = @"Will block others to see your corrent location";
            UISwitch *trackSwitch = [[UISwitch alloc] init];
            [trackSwitch addTarget:self action:@selector(didChangeSwitchValue:) forControlEvents:UIControlEventValueChanged];
            BOOL privacyFlag =  [[NSUserDefaults standardUserDefaults] boolForKey:kLocationPrivacyKey];
            trackSwitch.on = privacyFlag;
            trackSwitch.tag = 2001;
            cell.accessoryView = trackSwitch;
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell2"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell2"];
                cell.detailTextLabel.numberOfLines = 0;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Take a Walk Alert!";
            cell.detailTextLabel.text = @"Off";
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        // Profile
        HASignupInfoViewController *profileVC = [[HASignupInfoViewController alloc] init];
        profileVC.isSignUpMode = NO;
        profileVC.title = @"Profile";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:profileVC animated:YES];
        [self showPicker:NO];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        [self showPickerView];
    } else {
        [self showPicker:NO];
    }
}

- (void)didChangeSwitchValue:(UISwitch *)sender {
    if (sender.tag == 2001) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:kLocationPrivacyKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didTapMenuButton:(id)sender {
    [self presentLeftMenuViewController:nil];
}

- (void)showPickerView {
    if (!self.durationPickerView) {
        self.durationPickerView = [[UIPickerView alloc] init];
        self.durationPickerView.dataSource = self;
        self.durationPickerView.delegate = self;
        [self.durationPickerView setFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 216.0)];
        [self.durationPickerView setBackgroundColor:[UIColor whiteColor]];
        [[AppDelegate sharedAppDelegate].window addSubview:self.durationPickerView];
    }
    [self showPicker:YES];
    
    NSDictionary *alertValue = [[NSUserDefaults standardUserDefaults] valueForKey:kWalkAlertKey];
    if (!alertValue) {
        [self.durationPickerView selectRow:0 inComponent:0 animated:NO];
    }
    else {
        [self.durationPickerView selectRow:[self.pickerViewDataSource indexOfObject:alertValue] inComponent:0 animated:NO];
    }
}

- (void)showPicker:(BOOL)show {
    CGRect finalRect = self.durationPickerView.frame;
    if (show) {
        finalRect.origin.y= CGRectGetHeight(self.view.bounds)-CGRectGetHeight(finalRect);
    }
    else {
        finalRect.origin.y = CGRectGetHeight(self.view.bounds);
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.durationPickerView setFrame:finalRect];
    }];
}

- (NSArray *)pickerViewDataSource {
    if (!_pickerViewDataSource) {
        _pickerViewDataSource = @[@{@"Off":@"0"},
                                  @{@"15 seconds":@"0.25"},
                                  @{@"5 mins":@"5"},
                                  @{@"30 mins":@"30"},
                                  @{@"45 mins":@"45"},
                                  @{@"1 Hour":@"60"},
                                  @{@"1.5 Hours":@"90"},
                                  @{@"2 Hours":@"120"}];
    }
    return _pickerViewDataSource;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerViewDataSource count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[[self.pickerViewDataSource  objectAtIndex:row] allKeys] firstObject];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self resetAlertDurationCellWithValue:[self.pickerViewDataSource  objectAtIndex:row]];
    [self showPicker:NO];
}

- (void)resetAlertDurationCellWithValue:(NSDictionary *)dictionary {
    if (!dictionary) {
        dictionary = @{@"Off":@"0"};
    }
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:kWalkAlertKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *optionString = [[dictionary allKeys] firstObject];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    [cell.detailTextLabel setText:optionString];
    if ([optionString isEqualToString:@"Off"]) {
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    }
    else {
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.detailTextLabel setTextColor:[UIColor redColor]];
        [[AppDelegate sharedAppDelegate] scheduleLocalNNotification];
    }
}

@end
