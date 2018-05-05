//
//  BaseClassViewController.m
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import "BaseClassViewController.h"

@interface BaseClassViewController ()

@end

@implementation BaseClassViewController



-(void)checkCodeError:(NSDictionary *)dict {
    NSNumber *code = dict[@"statusCode"][@"meta"][@"status"];
    
    if ([code integerValue] == NSURLErrorNotConnectedToInternet) {
        [self showAlertWithOk:@"Info" message:@"No Internet Connection"];
    } else if ([code integerValue] == NSURLErrorTimedOut) {
        [self showAlertWithOk:@"Info" message:@"Request Timed Out"];
    } else if ([code integerValue] == NSURLErrorBadServerResponse){
        [self showAlertWithOk:@"Info" message:@"Service Unavailable"];
    }  else if ([code integerValue] == NSURLErrorCannotFindHost){
        [self showAlertWithOk:@"Info" message:@"A server with the specified hostname could not be found."];
    } else {
        NSException *exception = [NSException exceptionWithName: @"Exception!"
                                                         reason: @"service error"
                                                       userInfo: nil];
        @throw exception;
    }
}

-(void)showAlertWithOk:(NSString*)title message:(NSString*)message {
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [myAlert show];
}

-(void)showAlertRetryCancelWithTitle:(NSString*)title
                         withMessage:(NSString*)message
                    withRetryHandler:(void (^)(UIAlertAction *action))retryHandler
                   withCancelHandler:(void (^)(UIAlertAction *action))cancelHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title  message:message  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionRetry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:retryHandler];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:cancelHandler];
    [alertController addAction:actionCancel];
    [alertController addAction:actionRetry];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}

@end
