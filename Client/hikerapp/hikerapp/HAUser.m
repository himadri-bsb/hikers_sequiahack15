//
//  HAUser.m
//  hikerapp
//
//  Created by Himadri Jyoti on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HAUser.h"

NSString * const kKeyUserId = @"userID";
NSString * const kKeyUserName = @"userName";
NSString * const kKeyPhoneNumber = @"phoneNumber";
NSString * const kKeyGender = @"gender";
NSString * const kKeyLocation = @"location";
NSString * const kKeyImage = @"image";

/*
 
 @property (nonatomic, strong) NSString *userName;
 @property (nonatomic, strong) NSString *phoneNumber;
 @property (nonatomic, strong) NSString *gender;
 @property (nonatomic, strong) NSString *location;
 @property (nonatomic, strong) UIImage *image;
 
 */

@implementation HAUser

- (instancetype)initWithPFUser:(PFUser*)parseUser {
    if (self = [super init]) {
        self.parseUser = parseUser;
    }
    return self;
}


//User id
- (void)setUserID:(NSString*)userID {
    [self.parseUser setObject:userID forKey:kKeyUserId];
}

- (NSString*)userID {
    return [self.parseUser objectForKey:kKeyUserId];
}



//User name
- (void)setUserName:(NSString*)Name {
    [self.parseUser setObject:Name forKey:kKeyUserName];
}

- (NSString*)userName {
    return [self.parseUser objectForKey:kKeyUserName];
}


//User phone number
- (void)setPhoneNumber:(NSString *)phoneNumber {
    [self.parseUser setObject:phoneNumber forKey:kKeyPhoneNumber];
}

- (NSString*)phoneNumber {
    return [self.parseUser objectForKey:kKeyPhoneNumber];
}


//User gender
- (void)setGender:(NSString *)gender {
    [self.parseUser setObject:gender forKey:kKeyGender];
}

- (NSString *)gender {
    return [self.parseUser objectForKey:kKeyGender];
}


//User location
- (void)setLocation:(NSString *)location {
    [self.parseUser setObject:location forKey:kKeyLocation];
}

- (NSString *)location {
    return [self.parseUser objectForKey:kKeyLocation];
}


//User image
- (void)setImage:(UIImage *)image {
    [self.parseUser setObject:image forKey:kKeyImage];
}

- (UIImage *)image {
    return [self.parseUser objectForKey:kKeyImage];
}

@end
