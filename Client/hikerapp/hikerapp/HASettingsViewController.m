//
//  HASettingsViewController.m
//  hikerapp
//
//  Created by Mohan on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HASettingsViewController.h"
#import "HASignupInfoViewController.h"

@interface HASettingsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
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
//    if (section == 0) {
//        return 1;
//    } else {
//        return 2;
//    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.0f;
    } else {
        return 60.0f;
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
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsCell"];
            cell.detailTextLabel.numberOfLines = 0;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Allow to track location";
            cell.detailTextLabel.text = @"Will block others to see your corrent location";
            UISwitch *trackSwitch = [[UISwitch alloc] init];
            [trackSwitch addTarget:self action:@selector(didChangeSwitchValue:) forControlEvents:UIControlEventValueChanged];
            trackSwitch.tag = 2001;
            cell.accessoryView = trackSwitch;
        } else {
            cell.textLabel.text = @"Set maximum ideal time";
            cell.detailTextLabel.text = @"Will show alert if you stay ideal at the same palce for this much time";
        }
        return cell;
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
    }
}

- (void)didChangeSwitchValue:(UISwitch *)sender {
    if (sender.tag == 2001) {
        // Don't allow tracking
    }
}

@end
