//
//  BaseService.m
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import "BaseService.h"
#import "YBHud.h"
@implementation BaseService

# pragma mark - {GET} Method with AFNetworking
- (void)get:(NSString*)URL param:(NSDictionary *)param
    success:(successWithDictionary)success failure:(failureWithDictionary)failure{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer setTimeoutInterval:30];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    // indicator
    YBHud *hud = [[YBHud alloc]initWithHudType:DGActivityIndicatorAnimationTypeBallPulse andText:@"Loading"]; //Initialization
    
    hud.tintColor = [self colorFromHexString:@"#093353"];
    hud.UserInteractionDisabled = NO;
    hud.dimAmount = 0.5;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *rootViewController = window.rootViewController;
    UIView *masterView = rootViewController.view;

    [hud showInView:masterView animated:YES];
    
    operation = [manager GET:URL parameters:param progress:nil success:^(NSURLSessionTask * task, id responseObject) {
        
        [hud dismissAnimated:YES];
        
        
        NSDictionary *response = (NSDictionary*) responseObject;
        NSLog(@"responseObject URL %@ => %@", URL,responseObject);
        success(response);
        
    } failure:^(NSURLSessionTask * task, NSError *  resultError) {
        
        NSDictionary *resultErr = [self checkResultError:resultError task:task];
        
        NSLog(@"resultError URL %@ => %@", URL, resultError);
        failure(resultErr);
        [hud dismissAnimated:YES];

    }];
    
}

# pragma mark - check meta for error result from server
-(NSDictionary*)checkResultError:(NSError*)resultError task:(NSURLSessionTask*)task {
    NSDictionary *resultErr;
    NSData *errorResponse = (NSData *)resultError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSError *errorJson;
    NSDictionary *errorDict;
    @try{
        errorDict = [NSJSONSerialization JSONObjectWithData:errorResponse options:kNilOptions error:&errorJson];
    }@catch(NSException *ex){
        errorDict = nil;
    }
    
    if([[errorDict objectForKey:@"meta"] objectForKey:@"message"] == nil){
        if (resultError.code == NSURLErrorBadServerResponse) {
            resultErr = @{
                          @"statusCode": @{@"meta": @{@"status" : @-1011}},
                          @"reason":[NSNull null]
                          };
        } else if (resultError.code == NSURLErrorNotConnectedToInternet || resultError.code == NSURLErrorCannotConnectToHost) {
            resultErr = @{
                          @"statusCode": @{@"meta": @{@"status" : @-1009}},
                          @"reason":[NSNull null]
                          };
        } else if (resultError.code == NSURLErrorTimedOut) {
            resultErr = @{
                          @"statusCode": @{@"meta": @{@"status" : @-1001}},
                          @"reason":[NSNull null]
                          };
        } else if (resultError.code == NSURLErrorCannotFindHost) {
            resultErr = @{
                          @"statusCode": @{@"meta": @{@"status" : @-1003}},
                          @"reason":[NSNull null]
                          };
        } else {
            resultErr = @{
                          @"statusCode":[self getJSONInFailure:resultError],
                          @"reason":task.response
                          };
        }
    }else{
        resultErr = @{
                      @"statusCode": @{@"meta": @{@"status" : [errorDict objectForKey:@"code"] ,@"message":[errorDict objectForKey:@"message"]}},
                      @"reason":[errorDict objectForKey:@"message"]
                      };
    }
    return resultErr;
}


- (NSDictionary*)getJSONInFailure:(NSError*)error {
    NSDictionary* data = nil;
    if([[NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions error:nil] isEqual:[NSNull null]]){
        data = @{
                 @"message":@"An Error has Been Accoured."
                 };
    }else {
        data = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions error:nil];
    }
    
    return data;
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
}
@end
