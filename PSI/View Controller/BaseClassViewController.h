//
//  BaseClassViewController.h
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseClassViewController : UIViewController

-(void)checkCodeError:(NSDictionary *)dict;

-(void)showAlertRetryCancelWithTitle:(NSString*)title
                         withMessage:(NSString*)message
                    withRetryHandler:(void (^)(UIAlertAction *action))retryHandler
                   withCancelHandler:(void (^)(UIAlertAction *action))cancelHandler;

@end
