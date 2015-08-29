//
//  HASignUpManager.m
//  hikerapp
//
//  Created by Vijay on 29/08/15.
//  Copyright (c) 2015 Hike. All rights reserved.
//

#import "HASignUpManager.h"


@implementation HASignUpManager

+ (void)signUpWithMISISDN:(NSString *)msisdn
                 withName:(NSString *)name
                withImage:(UIImage *)image
         withGenderString:(NSString *)genderString
             onCompletion:(SignUpCompletion)completion {

    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://100.117.103.45:8080/MyNews/rest/signup?userName=%@&gender=%@&phNumber=%@",name,genderString,msisdn];

    NSString* urlEncodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlEncodedString]];
    [request setHTTPMethod:@"POST"];

    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"YOUR_BOUNDARY_STRING";

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpg\"\r\n", @"msisdn"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user\"\r\n\r\n%d", 1] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)imageData.length] forHTTPHeaderField:@"content-Length"];
    [request setValue:[NSString stringWithFormat:@"%@%@", @"multipart/form-data; boundary=",boundary] forHTTPHeaderField:@"Content-Type"];


    [request setHTTPBody:body];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               //TODO:Waiting fpr proper response from server
                               NSLog(@"Response %@",str);
                               if (completion) {
                                   completion(YES);
                               }

                           }];
}

@end
