//
//  BaseService.h
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@interface BaseService : NSObject{
    NSURLSessionTask *operation;
}


typedef void(^successWithDictionary)(NSDictionary*);

typedef void(^failureWithDictionary)(NSDictionary*);

- (NSDictionary*) getJSONInFailure:(NSError*)error;

- (void)get:(NSString*)URL param:(NSDictionary *)param
    success:(successWithDictionary)success failure:(failureWithDictionary)failure;

@end
