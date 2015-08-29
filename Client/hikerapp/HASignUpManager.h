//
//  HASignUpManager.h
//  hikerapp
//
//  Created by Vijay on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SignUpCompletion)(BOOL success);

@interface HASignUpManager : NSObject

+ (void)signUpWithMISISDN:(NSString *)msisdn
                     withName:(NSString *)name
             withImage:(UIImage *)image
      withGenderString:(NSString *)genderString
             onCompletion:(SignUpCompletion)completion;


@end
