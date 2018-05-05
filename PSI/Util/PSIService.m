//
//  PSIService.m
//  PSI
//
//  Created by WGS-LAP189 on 04/05/18.
//  Copyright © 2018 Adie. All rights reserved.
//

#import "PSIService.h"

@implementation PSIService{
       BaseService *service;
}

- (void)getMapPSI:(successWithDictionary)success failure:(failureWithDictionary)failure{
    service = [BaseService new];
    NSString *URL = [NSString stringWithFormat:@"%@", psiUrl];
    
    [service get:URL param:nil success:success failure:failure];
}
@end
