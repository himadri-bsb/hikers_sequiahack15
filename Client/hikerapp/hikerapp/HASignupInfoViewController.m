//
//  HASignupInfoViewController.m
//  hikerapp
//
//  Created by Mohan on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HASignupInfoViewController.h"
#import <DigitsKit/DigitsKit.h>
#import "HAUser.h"
#import "HAModelManager.h"
#import "AppDelegate.h"
#import "UIImage+Resize.h"


@interface HASignupInfoViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *maleButton;
@property (nonatomic, strong) UIButton *femaleButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) DGTSession *session;
@end

@implementation HASignupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavigationBar];
    [self setupUI];
    [self setLayoutConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigationBar {
    if(self.isSignUpMode) {
        [self.navigationController.navigationBar setHidden:YES];
    }
}

- (void)setupUI {
    
    self.bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bgView setImage:[UIImage imageNamed:@"signup_bg"]];
    [self.view addSubview:self.bgView];
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarImageView.layer.cornerRadius = 60.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
    [self.avatarImageView setUserInteractionEnabled:YES];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.avatarImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(changeAvatarAction:)];
    [self.avatarImageView addGestureRecognizer:tapGesture];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameTextField.layer.borderWidth = 1.0f;
    self.nameTextField.layer.cornerRadius = 20.0f;
    self.nameTextField.textColor = [UIColor whiteColor];
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 14.0f, 40.0f)];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.delegate = self;
    NSAttributedString *placeholderStr = [[NSAttributedString alloc] initWithString:@"Name"
                                                               attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    self.nameTextField.attributedPlaceholder = placeholderStr;
    [self.view addSubview:self.nameTextField];
    
    self.maleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.maleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.maleButton setImage:[UIImage imageNamed:@"male_selected"] forState:UIControlStateNormal];
    [self.maleButton addTarget:self action:@selector(maleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.maleButton];
    
    self.femaleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.femaleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.femaleButton setImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
    [self.femaleButton addTarget:self action:@selector(femaleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.femaleButton];
    
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.submitButton setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:150.0f/255.0f blue:174.0f/255.0f alpha:0.8f]];
    if (self.isSignUpMode) {
        [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    } else {
        [self.submitButton setTitle:@"Update" forState:UIControlStateNormal];
    }
    [self.submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}

- (void)setLayoutConstraints {
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                        views:@{@"view":self.bgView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"view":self.bgView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.nameTextField
                                                         attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f constant:-40.0f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==width)]"
                                                                      options:0
                                                                      metrics:@{@"width":@(120.f)}
                                                                        views:@{@"view":self.avatarImageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==height)]"
                                                                      options:0
                                                                      metrics:@{@"height":@(120.f)}
                                                                        views:@{@"view":self.avatarImageView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameTextField
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameTextField
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f constant:-10.0f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==width)]"
                                                                     options:0
                                                                      metrics:@{@"width":@(200.0f)}
                                                                        views:@{@"view":self.nameTextField}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==height)]"
                                                                      options:0
                                                                      metrics:@{@"height":@(40.0f)}
                                                                        views:@{@"view":self.nameTextField}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.maleButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:-20.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.maleButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameTextField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f constant:40.0f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==60)]"
                                                                      options:0
                                                                      metrics:nil views:@{@"view":self.maleButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==60)]"
                                                                      options:0
                                                                      metrics:nil views:@{@"view":self.maleButton}]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.femaleButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:20.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.femaleButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameTextField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f constant:40.0f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==60)]"
                                                                      options:0
                                                                      metrics:nil views:@{@"view":self.femaleButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==60)]"
                                                                      options:0
                                                                      metrics:nil views:@{@"view":self.femaleButton}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                        views:@{@"view":self.submitButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==60.0)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"view":self.submitButton}]];
}

#pragma mark - Button actions

- (void)submitButtonAction:(id)sender {
    // Show loader
    dispatch_async(dispatch_get_main_queue(), ^{
        //Display progress indicator
        [[AppDelegate sharedAppDelegate] showLoader:YES];
    });
    
    HAUser *currentUser = [[HAModelManager sharedManager] currentUser];
    currentUser.parseUser.username = self.session.phoneNumber;
    currentUser.parseUser.password = self.session.userID;
    
    //Handle Parse login
    [currentUser.parseUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Registration success!");
                currentUser.phoneNumber = self.session.phoneNumber;
                currentUser.userName = self.nameTextField.text;
                currentUser.userID = self.session.userID;
                currentUser.image = self.avatarImageView.image;
                
                [currentUser.parseUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        if(succeeded) {
                            //Sign up complete
                            [[AppDelegate sharedAppDelegate] showLoader:NO];
                        }
                        else {
                            if(error) {
                                NSLog(@"setUpDigitButton error on saving daya, error = %@",error);
                            }
                        }
                    });
                }];
            });
        }
        else {
            //Signup failed, try logging in
            [PFUser logInWithUsernameInBackground:self.session.phoneNumber
                                         password:self.session.userID
                                            block:^(PFUser *user, NSError *error) {
                                                if(user) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        NSLog(@"Registration success!");
                                                        currentUser.parseUser = user;
                                                        currentUser.phoneNumber = self.session.phoneNumber;
                                                        currentUser.userName = self.nameTextField.text;
                                                        currentUser.userID = self.session.userID;
                                                        currentUser.image = self.avatarImageView.image;
                                                        
                                                        [currentUser.parseUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                            dispatch_async(dispatch_get_main_queue(), ^ {
                                                                if(succeeded) {
                                                                    //Sign up complete
                                                                    [[AppDelegate sharedAppDelegate] showLoader:NO];
                                                                    [[AppDelegate sharedAppDelegate] handleSignUpComplete];
                                                                }
                                                                else {
                                                                    if(error) {
                                                                        NSLog(@"setUpDigitButton error on saving daya, error = %@",error);
                                                                    }
                                                                }
                                                            });
                                                        }];
                                                    });
                                                }
                                                else {
                                                    NSLog(@"Registration Failed!");
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[AppDelegate sharedAppDelegate] showLoader:NO];
                                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error = %@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                        [alertView show];
                                                    });
                                                }
                                                
                                            }];
        }
    }];
}

- (void)maleButtonAction:(id)sender {
    [self.femaleButton setImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
    [self.maleButton setImage:[UIImage imageNamed:@"male_selected"] forState:UIControlStateNormal];
}

- (void)femaleButtonAction:(id)sender {
    [self.femaleButton setImage:[UIImage imageNamed:@"female_selected"] forState:UIControlStateNormal];
    [self.maleButton setImage:[UIImage imageNamed:@"male"] forState:UIControlStateNormal];
}

- (void)changeAvatarAction:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    self.avatarImageView.image = [image  resizedImage:CGSizeMake(100, 100) interpolationQuality:kCGInterpolationMedium];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)digitsAuthenticationFinishedWithSession:(DGTSession *)aSession error:(NSError *)error {
    if(!error) {
        self.session = aSession;
    }
    else {
        NSLog(@"Registration Failed!");
        // Show error
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate sharedAppDelegate] showLoader:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error = %@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        });
    }

}

@end
